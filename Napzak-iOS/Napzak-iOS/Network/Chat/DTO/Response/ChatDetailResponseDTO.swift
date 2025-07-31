//
//  ChatDetailResponseDTO.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 7/24/25.
//

typealias ChatDetailResponseDTO = BaseResponseDTO<ChatDetailInfoDTO>

struct ChatDetailInfoDTO: Decodable {
    let productInfo: ChatProductInfoDTO
    let storeInfo: ChatStoreInfoDTO
    let roomId: Int?
}

struct ChatProductInfoDTO: Decodable {
    let productId: Int
    let photo: String
    let tradeType: TradeType
    let title: String
    let price: Int
    let isPriceNegotiable: Bool
    let genreName: String
}

struct ChatStoreInfoDTO: Decodable {
    let storeId: Int
    let nickname: String
    let isWithdrawn: Bool
    let storePhoto: String
}
