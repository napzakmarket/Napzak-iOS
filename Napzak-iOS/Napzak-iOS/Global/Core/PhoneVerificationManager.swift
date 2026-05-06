//
//  PhoneVerificationManager.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/27/26.
//

import Foundation
import os

enum PhoneVerificationGateStatus: Equatable {
    case unknown
    case verified
    case unverified
}

@MainActor
final class PhoneVerificationManager: ObservableObject {
    @Published private(set) var verificationStatus: PhoneVerificationGateStatus = .unknown
    @Published private(set) var isModalPresented: Bool = false
    @Published private(set) var currentEntryPoint: PhoneVerificationEntryPoint?
    @Published private(set) var hasShownHomeModalInCurrentSession: Bool = false

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "PhoneVerification")
    private let repository: PhoneVerificationRepository

    init(repository: PhoneVerificationRepository = DefaultPhoneVerificationRepository()) {
        self.repository = repository
    }

    var isPhoneVerified: Bool {
        verificationStatus == .verified
    }

    func setPhoneVerified(_ isPhoneVerified: Bool) {
        verificationStatus = isPhoneVerified ? .verified : .unverified
        logger.info("setPhoneVerified called - isPhoneVerified: \(isPhoneVerified)")

        if isPhoneVerified {
            dismissModal()
        }
    }

    func reset() {
        verificationStatus = .unknown
        isModalPresented = false
        currentEntryPoint = nil
        hasShownHomeModalInCurrentSession = false
    }

    func setEntryPoint(_ entryPoint: PhoneVerificationEntryPoint?) {
        currentEntryPoint = entryPoint
    }

    @discardableResult
    func presentModal(for entryPoint: PhoneVerificationEntryPoint) -> Bool {
        guard verificationStatus == .unverified else {
            logger.info("Skipped modal presentation because phone is already verified")
            return false
        }

        if entryPoint == .homeModal {
            guard hasShownHomeModalInCurrentSession == false else {
                logger.info("Skipped home modal presentation because it was already shown in this session")
                return false
            }

            hasShownHomeModalInCurrentSession = true
        }

        currentEntryPoint = entryPoint
        isModalPresented = true
        logger.info("Presented phone verification modal for entryPoint")
        return true
    }

    func dismissModal() {
        isModalPresented = false
    }

    func resetSessionPresentationState() {
        isModalPresented = false
        currentEntryPoint = nil
        hasShownHomeModalInCurrentSession = false
    }

    func canPresentHomeModal() -> Bool {
        verificationStatus == .unverified
        && hasShownHomeModalInCurrentSession == false
    }

    @discardableResult
    func resolveVerificationStatusIfNeeded() async -> PhoneVerificationGateStatus {
        if verificationStatus != .unknown {
            return verificationStatus
        }

        return await refreshStatus()
    }

    @discardableResult
    func refreshStatus() async -> PhoneVerificationGateStatus {
        let result = await repository.fetchStatus()

        switch result {
        case .success(let status):
            verificationStatus = status.isPhoneVerified ? .verified : .unverified
            logger.info("refreshStatus success - isPhoneVerified: \(status.isPhoneVerified)")
            return verificationStatus

        case .failure(let error):
            logger.error("refreshStatus failed: \(error.localizedDescription) - keeping verification status unknown")
            return .unknown
        }
    }
}
