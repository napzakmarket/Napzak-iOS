//
//  StoreDetailDTO.swift
//  Napzak-iOS
//
//  Created by 어진 on 5/3/25.
//

struct StoreDetailDTO: Decodable {
    let storeId: Int
    let storeNickName: String?
    let storeDescription: String?
    let storePhoto: String?
    let storeCover: String?
    let isStoreOwner: Bool
    let isStoreBlocked: Bool
    let genrePreferences: [GenreDTO]
}

typealias StoreDetailResponseDTO = BaseResponseDTO<StoreDetailDTO>
