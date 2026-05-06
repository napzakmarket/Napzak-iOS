//
//  PhoneVerificationRemoteDataSource.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/26/26.
//

import Foundation

protocol PhoneVerificationRemoteDataSource {
    func fetchStatus() async -> Result<PhoneVerificationStatusResponseDTO, NetworkError>
    func sendCode(phoneNumber: String) async -> Result<PhoneVerificationSendCodeResponseDTO, NetworkError>
    func verifyCode(phoneNumber: String, code: String) async -> Result<PhoneVerificationVerifyCodeResponseDTO, NetworkError>
}
