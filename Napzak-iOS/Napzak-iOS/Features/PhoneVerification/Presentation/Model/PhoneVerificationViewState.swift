//
//  PhoneVerificationViewState.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/26/26.
//

import Foundation

struct PhoneVerificationViewState: Equatable {
    var session: PhoneVerificationSession = .empty
    var remainingSeconds: Int = 0
    var remainingRequestCount: Int?
    var isSendingCode = false
    var toastType: VerificationToastType?

    var timerText: String {
        if session.isCodeSent == false {
            return "03:00"
        }

        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var isVerificationSectionVisible: Bool {
        session.isCodeSent
    }

    var isResendAvailable: Bool {
        session.isCodeSent
        && session.isVerified == false
        && remainingSeconds == 0
        && (remainingRequestCount ?? 0) > 0
    }

    var isSendButtonEnabled: Bool {
        session.name.isEmpty == false
        && session.phoneNumber.isEmpty == false
    }

    var verifyButtonState: VerifyButtonState {
        if session.isVerified {
            return .completed
        }

        guard session.isCodeSent, remainingSeconds > 0 else {
            return .disabled
        }

        return session.verificationCode.count == 6 ? .enabled : .disabled
    }

    var isNextEnabled: Bool {
        session.isVerified && session.isAgeConfirmed
    }
}
