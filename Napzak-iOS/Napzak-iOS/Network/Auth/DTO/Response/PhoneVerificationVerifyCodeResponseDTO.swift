//
//  PhoneVerificationVerifyCodeResponseDTO.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/26/26.
//

import Foundation

typealias PhoneVerificationVerifyCodeResponseDTO = BaseResponseDTO<PhoneVerificationVerifyCodeDataDTO>

struct PhoneVerificationVerifyCodeDataDTO: Decodable {
    let isCodeMatched: Bool
    let remainingRequestCount: Int
}
