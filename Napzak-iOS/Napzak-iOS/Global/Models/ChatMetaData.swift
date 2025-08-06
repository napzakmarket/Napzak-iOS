//
//  ChatMetaData.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 7/28/25.
//

struct ImageMeta: Codable {
    let type: ChatMessageType
    let imageUrls: [String?]
}

struct ProductMeta: Codable {
    let type: ChatMessageType
    let tradeType: TradeType
    let productId: Int
    let genreName: String
    let title: String
    let price: Int
}

struct SystemMeta: Codable {
    let type: SystemMetaType
    let content: String
}

struct DateMeta: Codable {
    let type: ChatMessageType
    let date: String
}
