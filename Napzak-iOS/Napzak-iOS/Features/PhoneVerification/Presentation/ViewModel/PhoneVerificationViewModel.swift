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
        updateState {
            $0.session = $0.session.copy(name: name)
        }
    }

    func updatePhoneNumber(_ phoneNumber: String) {
        invalidateVerificationSession()

        updateState {
            $0.session = $0.session.copy(
                phoneNumber: phoneNumber.normalizedPhoneNumberInput,
                verificationCode: "",
                isCodeSent: false,
                isCodeVerified: false
            )
            $0.toastType = nil
        }
    }

    func updateVerificationCode(_ code: String) {
        updateState {
            $0.session = $0.session.copy(
                verificationCode: String(code.digitsOnly.prefix(6)),
                isCodeVerified: false
            )
        }
    }

    func toggleAgeConfirmation() {
        updateState {
            $0.session = $0.session.copy(
                isAgeConfirmed: !$0.session.isAgeConfirmed
            )
        }
    }

    func requestCode() async {
        if let validationToastType = sendValidationToastType {
            showToast(validationToastType)
            return
        }

        updateState {
            $0.isSendingCode = true
        }
        defer {
            updateState {
                $0.isSendingCode = false
            }
        }

        let result = await requestCodeUseCase.execute(
            phoneNumber: state.session.phoneNumber
        )

        switch result {
        case .success(let sendResult):
            updateState {
                $0.session = $0.session.copy(
                    verificationCode: "",
                    isCodeSent: true,
                    isCodeVerified: false
                )
                $0.remainingRequestCount = sendResult.remainingRequestCount
                $0.remainingSeconds = 180
            }
            startTimer()
            showToast(.verificationCodeSent)

        case .failure(let error):
            handleCodeRequestFailure(error)
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
            updateState {
                $0.session = $0.session.copy(
                    isCodeVerified: verificationResult.isPhoneVerified
                )
                $0.remainingRequestCount = verificationResult.remainingRequestCount
            }

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

    func applyExistingPhoneVerification() {
        timerTask?.cancel()

        updateState {
            $0.session = $0.session.copy(
                isCodeSent: true,
                isCodeVerified: true
            )
            $0.remainingSeconds = 0
            $0.toastType = nil
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

                self.updateState {
                    $0.remainingSeconds -= 1
                }
            }

            guard Task.isCancelled == false,
                  self.state.session.isCodeSent,
                  self.state.session.isCodeVerified == false,
                  self.state.remainingSeconds == 0 else {
                return
            }

            self.resetVerificationCodeInput()
            self.showToast(.verificationCodeExpired)
        }
    }

    func invalidateVerificationSession() {
        timerTask?.cancel()
        updateState {
            $0.remainingSeconds = 0
            $0.remainingRequestCount = nil
        }
    }

    func resetVerificationCodeInput() {
        updateState {
            $0.session = $0.session.copy(
                verificationCode: "",
                isCodeVerified: false
            )
        }
    }

    func expireVerificationSession() {
        timerTask?.cancel()
        updateState {
            $0.remainingSeconds = 0
        }
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

    func handleCodeRequestFailure(_ error: PhoneVerificationError) {
        switch error {
        case .requestLimitExceeded:
            updateState {
                $0.remainingRequestCount = 0
            }
            showToast(.verificationRequestLimitExceeded)

        default:
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
        updateState {
            $0.toastType = toastType
        }

        Task { [weak self] in
            try? await Task.sleep(for: .seconds(2))
            guard let self, self.state.toastType == toastType else { return }
            self.updateState {
                $0.toastType = nil
            }
        }
    }

    func updateState(_ transform: (inout PhoneVerificationViewState) -> Void) {
        var newState = state
        transform(&newState)
        state = newState
    }
}
