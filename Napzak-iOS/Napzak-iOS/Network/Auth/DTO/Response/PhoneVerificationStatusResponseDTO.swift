//
//  PhoneVerificationStatusResponseDTO.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/26/26.
//

import Foundation

typealias PhoneVerificationStatusResponseDTO = BaseResponseDTO<PhoneVerificationStatusDataDTO>

struct PhoneVerificationStatusDataDTO: Decodable {
    let isPhoneVerified: Bool
}
