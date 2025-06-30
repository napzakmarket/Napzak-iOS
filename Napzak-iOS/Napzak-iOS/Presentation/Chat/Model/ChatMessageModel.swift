//
//  ChatMessageModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 6/30/25.
//

enum ChatMessageType: String {
    case text = "TEXT"
    case image = "IMAGE"
    case product = "PRODUCT"
    case system = "SYSTEM"
    case date = "DATE"
}

enum ChatMetaDataType {
    case image(ImageMeta)
    case product(ProductMeta)
    case system(SystemMeta)
    case date(DateMeta)
}

enum SystemMetaType: String {
    case leave = "LEAVE"
    case reported = "REPORTED"
    case withdrawn = "WITHDRAWN"
}

struct ChatMessageModel {
    let messageId: Int
    let senderId: Int
    let type: ChatMessageType
    let content: String?
    let metaData: ChatMetaDataType?
    let createdAt: String
    let isFirstChat: Bool
    let isReceived: Bool
    let isRead: Bool
}

struct ImageMeta {
    let type: ChatMessageType
    let imageUrls: [String]
}

struct ProductMeta {
    let type: ChatMessageType
    let tradeType: TradeType
    let productId: Int
    let genreName: String
    let title: String
    let price: Int
}

struct SystemMeta {
    let type: SystemMetaType
    let content: String
}

struct DateMeta {
    let type: ChatMessageType
    let date: String
}

extension ChatMessageModel {
    static let mock: [ChatMessageModel] = [
        ChatMessageModel(
            messageId: 2,
            senderId: 2,
            type: .product,
            content: nil,
            metaData: .product(
                ProductMeta(
                    type: .product,
                    tradeType: .sell,
                    productId: 0,
                    genreName: "은혼",
                    title: "은혼 긴토키 히지카타 룩업",
                    price: 123000
                )
            ),
            createdAt: "오전 7:30",
            isFirstChat: false,
            isReceived: true,
            isRead: true
        ),
        ChatMessageModel(
            messageId: 0,
            senderId: 0,
            type: .text,
            content: "메시진데요",
            metaData: nil,
            createdAt: "오전 7:30",
            isFirstChat: false,
            isReceived: false,
            isRead: false
        ),
        ChatMessageModel(
            messageId: 1,
            senderId: 1,
            type: .image,
            content: nil,
            metaData: .image(
                ImageMeta(
                    type: .image,
                    imageUrls: ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOrPQwOTaU_L8EIFpWzLjgiUHc3CcmGEq84A&s"]
                )
            ),
            createdAt: "오전 7:30",
            isFirstChat: true,
            isReceived: true,
            isRead: true
        ),
        ChatMessageModel(
            messageId: 3,
            senderId: 3,
            type: .date,
            content: nil,
            metaData: .date(
                DateMeta(type: .date, date: "2025년 4월 30일")
            ),
            createdAt: "오전 7:30",
            isFirstChat: false,
            isReceived: false,
            isRead: true
        ),
        ChatMessageModel(
            messageId: 4,
            senderId: 4,
            type: .system,
            content: nil,
            metaData: .system(
                SystemMeta(
                    type: .reported,
                    content: ""
                )
            ),
            createdAt: "오전 7:30",
            isFirstChat: false,
            isReceived: false,
            isRead: true
        )
    ]
}
