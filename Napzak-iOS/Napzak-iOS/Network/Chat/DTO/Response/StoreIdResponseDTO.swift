//
//  StoreIdResponseDTO.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 7/28/25.
//

typealias StoreIdResponseDTO = BaseResponseDTO<StoreIdDTO>

struct StoreIdDTO: Decodable {
    let storeId: Int
}
