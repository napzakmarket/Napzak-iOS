//
//  PhoneVerificationSendCodeResponseDTO.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/26/26.
//

import Foundation

typealias PhoneVerificationSendCodeResponseDTO = BaseResponseDTO<PhoneVerificationSendCodeDataDTO>

struct PhoneVerificationSendCodeDataDTO: Decodable {
    let remainingRequestCount: Int
}
