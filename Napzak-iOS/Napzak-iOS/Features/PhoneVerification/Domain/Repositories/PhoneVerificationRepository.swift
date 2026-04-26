//
//  PhoneVerificationRepository.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/26/26.
//

import Foundation

protocol PhoneVerificationRepository {
    func fetchStatus() async -> Result<PhoneVerificationStatus, PhoneVerificationError>
    func requestCode(for phoneNumber: String) async -> Result<PhoneVerificationCodeSendResult, PhoneVerificationError>
    func verifyCode(_ code: String, phoneNumber: String) async -> Result<PhoneVerificationCodeVerificationResult, PhoneVerificationError>
}
