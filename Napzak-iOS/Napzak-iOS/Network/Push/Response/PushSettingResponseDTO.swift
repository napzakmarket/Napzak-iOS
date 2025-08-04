//
//  PushSettingResponseDTO.swift
//  Napzak-iOS
//
//  Created by 조호근 on 7/8/25.
//

import Foundation

typealias PushSettingResponseDTO = BaseResponseDTO<PushSettingData>

struct PushSettingData: Decodable {
    let allowMessage: Bool
}
