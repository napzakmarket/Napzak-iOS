//
//  StoreModifyProfileResponseDTO.swift
//  Napzak-iOS
//
//  Created by 어진 on 5/3/25.
//

import Foundation

struct StoreModifyProfileDetailDTO: Decodable {
    let storeCover: String
    let storePhoto: String
    let storeNickName: String
    let storeDescription: String
    let preferredGenreList: [GenreDTO]
}

typealias StoreModifyProfileResponseDTO = BaseResponseDTO<StoreModifyProfileDetailDTO>
