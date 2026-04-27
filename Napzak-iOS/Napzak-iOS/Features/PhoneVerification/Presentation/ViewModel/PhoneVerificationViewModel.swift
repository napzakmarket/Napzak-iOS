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
        state.toastType = nil
    }

    func updateVerificationCode(_ code: String) {
        state.session = state.session.copy(
            verificationCode: String(code.digitsOnly.prefix(6)),
            isVerified: false
        )
    }

    func toggleAgeConfirmation() {
        state.session = state.session.copy(
            isAgeConfirmed: !state.session.isAgeConfirmed
        )
    }

    func requestCode() async {
        if let validationToastType = sendValidationToastType {
            showToast(validationToastType)
            return
        }

        state.isSendingCode = true
        defer { state.isSendingCode = false }

        let result = await requestCodeUseCase.execute(
            phoneNumber: state.session.phoneNumber
        )

        switch result {
        case .success(let sendResult):
            state.session = state.session.copy(
                verificationCode: "",
                isCodeSent: true,
                isVerified: false
            )
            state.remainingRequestCount = sendResult.remainingRequestCount
            state.remainingSeconds = 180
            startTimer()
            showToast(.verificationCodeSent)

        case .failure(let error):
            showToast(mapToastType(from: error))
        }
    }

    func resendCode() async {
        guard state.isResendAvailable else { return }
        await requestCode()
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
            state.remainingRequestCount = verificationResult.remainingRequestCount

            if verificationResult.isPhoneVerified {
                timerTask?.cancel()
            }

            if verificationResult.isPhoneVerified == false {
                resetVerificationCodeInput()
                showToast(.invalidVerificationCode)
            }

        case .failure(let error):
            handleVerificationFailure(error)
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

            guard Task.isCancelled == false,
                  self.state.session.isCodeSent,
                  self.state.session.isVerified == false,
                  self.state.remainingSeconds == 0 else {
                return
            }

            self.resetVerificationCodeInput()
            self.showToast(.verificationCodeExpired)
        }
    }

    func invalidateVerificationSession() {
        timerTask?.cancel()
        state.remainingSeconds = 0
        state.remainingRequestCount = nil
    }

    func resetVerificationCodeInput() {
        state.session = state.session.copy(
            verificationCode: "",
            isVerified: false
        )
    }

    func expireVerificationSession() {
        timerTask?.cancel()
        state.remainingSeconds = 0
        resetVerificationCodeInput()
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
        case .expiredOrMissingSession:
            return .verificationCodeExpired
        case .tooManyVerificationAttempts:
            return .tooManyVerificationAttempts
        case .unauthorized, .invalidRequest, .unknown:
            return .verificationCodeRequestFailed
        }
    }

    func handleVerificationFailure(_ error: PhoneVerificationError) {
        switch error {
        case .expiredOrMissingSession:
            expireVerificationSession()
            showToast(.verificationCodeExpired)

        case .tooManyVerificationAttempts:
            expireVerificationSession()
            showToast(.tooManyVerificationAttempts)

        case .networkDisconnected:
            showToast(.networkDisconnected)

        case .unauthorized, .invalidRequest, .unknown:
            showToast(.verificationCodeConfirmFailed)

        case .alreadyRegisteredPhoneNumber,
                .alreadyVerifiedMember,
                .blockedPhoneNumber,
                .requestLimitExceeded:
            showToast(mapToastType(from: error))
        }
    }

    var sendValidationToastType: VerificationToastType? {
        if let nameValidationToastType = validateName(state.session.name) {
            return nameValidationToastType
        }

        if let phoneValidationToastType = validatePhoneNumber(state.session.phoneNumber) {
            return phoneValidationToastType
        }

        return nil
    }

    func validateName(_ name: String) -> VerificationToastType? {
        if name.isEmpty {
            return .invalidName
        }

        if name.count < 2 || name.count > 20 {
            return .invalidName
        }

        let completeHangulPattern = "^[가-힣]+$"
        let hasOnlyCompleteHangul = name.range(
            of: completeHangulPattern,
            options: .regularExpression
        ) != nil

        return hasOnlyCompleteHangul ? nil : .invalidName
    }

    func validatePhoneNumber(_ phoneNumber: String) -> VerificationToastType? {
        if phoneNumber.isEmpty {
            return .invalidPhoneNumber
        }

        return (10...11).contains(phoneNumber.digitsOnly.count)
        ? nil
        : .invalidPhoneNumber
    }

    func showToast(_ toastType: VerificationToastType) {
        state.toastType = toastType

        Task { [weak self] in
            try? await Task.sleep(for: .seconds(2))
            guard let self, self.state.toastType == toastType else { return }
            self.state.toastType = nil
        }
    }
}
