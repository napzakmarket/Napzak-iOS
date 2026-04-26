//
//  PhoneVerificationViewModel.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/26/26.
//

import Foundation

@MainActor
final class PhoneVerificationViewModel: ObservableObject {
    @Published private(set) var state = PhoneVerificationViewState()

    private let requestCodeUseCase: RequestPhoneVerificationCodeUseCase
    private let verifyCodeUseCase: VerifyPhoneVerificationCodeUseCase
    private var timerTask: Task<Void, Never>?

    init(
        requestCodeUseCase: RequestPhoneVerificationCodeUseCase = RequestPhoneVerificationCodeUseCase(
            repository: DefaultPhoneVerificationRepository()
        ),
        verifyCodeUseCase: VerifyPhoneVerificationCodeUseCase = VerifyPhoneVerificationCodeUseCase(
            repository: DefaultPhoneVerificationRepository()
        )
    ) {
        self.requestCodeUseCase = requestCodeUseCase
        self.verifyCodeUseCase = verifyCodeUseCase
    }

    deinit {
        timerTask?.cancel()
    }

    func updateName(_ name: String) {
        state.session = state.session.copy(name: name)
    }

    func updatePhoneNumber(_ phoneNumber: String) {
        invalidateVerificationSession()

        state.session = state.session.copy(
            phoneNumber: phoneNumber.normalizedPhoneNumberInput,
            verificationCode: "",
            isCodeSent: false,
            isVerified: false
        )
    }

    func updateVerificationCode(_ code: String) {
        state.session = state.session.copy(
            verificationCode: code,
            isVerified: false
        )
    }

    func toggleAgeConfirmation() {
        state.session = state.session.copy(
            isAgeConfirmed: !state.session.isAgeConfirmed
        )
    }

    func requestCode() async {
        guard state.isSendButtonEnabled else { return }

        state.isSendingCode = true
        defer { state.isSendingCode = false }

        let result = await requestCodeUseCase.execute(
            phoneNumber: state.session.phoneNumber
        )

        switch result {
        case .success:
            state.session = state.session.copy(
                verificationCode: "",
                isCodeSent: true,
                isVerified: false
            )
            state.remainingSeconds = 180
            startTimer()
            state.toastType = .verificationCodeSent

        case .failure(let error):
            state.toastType = mapToastType(from: error)
        }
    }

    func verifyCode() async {
        guard state.verifyButtonState == .enabled else { return }

        let result = await verifyCodeUseCase.execute(
            code: state.session.verificationCode,
            phoneNumber: state.session.phoneNumber
        )

        switch result {
        case .success(let verificationResult):
            state.session = state.session.copy(
                isVerified: verificationResult.isPhoneVerified
            )

            if verificationResult.isPhoneVerified {
                timerTask?.cancel()
            }

            if verificationResult.isPhoneVerified == false {
                state.toastType = .verificationCodeConfirmFailed
            }

        case .failure(let error):
            state.toastType = mapToastType(from: error)
        }
    }
}

private extension PhoneVerificationViewModel {
    func startTimer() {
        timerTask?.cancel()

        timerTask = Task { [weak self] in
            guard let self else { return }

            while Task.isCancelled == false, self.state.remainingSeconds > 0 {
                try? await Task.sleep(for: .seconds(1))

                guard Task.isCancelled == false else { return }

                self.state.remainingSeconds -= 1
            }
        }
    }

    func invalidateVerificationSession() {
        timerTask?.cancel()
        state.remainingSeconds = 0
    }

    func mapToastType(from error: PhoneVerificationError) -> VerificationToastType {
        switch error {
        case .alreadyRegisteredPhoneNumber, .alreadyVerifiedMember:
            return .phoneNumberAlreadyRegistered
        case .blockedPhoneNumber:
            return .phoneNumberBlocked
        case .requestLimitExceeded:
            return .verificationRequestLimitExceeded
        case .networkDisconnected:
            return .networkDisconnected
        case .expiredOrMissingSession, .tooManyVerificationAttempts:
            return .verificationCodeConfirmFailed
        case .unauthorized, .invalidRequest, .unknown:
            return .verificationCodeRequestFailed
        }
    }
}
