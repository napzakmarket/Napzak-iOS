//
//  PhoneVerificationVerifyCodeRequestDTO.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/26/26.
//

import Foundation

struct PhoneVerificationVerifyCodeRequestDTO: Encodable {
    let phoneNumber: String
    let code: String
}
