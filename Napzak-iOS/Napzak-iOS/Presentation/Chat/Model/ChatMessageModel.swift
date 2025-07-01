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

struct ChatMessageModel: Identifiable {
    let id: Int
    let senderId: Int
    let type: ChatMessageType
    let content: String?
    let metaData: ChatMetaDataType?
    let createdAt: String
    let isFirstChat: Bool
    let isMessageOwner: Bool
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
            id: 0,
            senderId: 3,
            type: .date,
            content: nil,
            metaData: .date(
                DateMeta(type: .date, date: "2025년 4월 30일")
            ),
            createdAt: "오전 7:30",
            isFirstChat: false,
            isMessageOwner: false,
            isRead: true
        ),
        ChatMessageModel(
            id: 1,
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
            isMessageOwner: false,
            isRead: true
        ),
        ChatMessageModel(
            id: 2,
            senderId: 0,
            type: .text,
            content: "구매할래요",
            metaData: nil,
            createdAt: "오전 7:30",
            isFirstChat: true,
            isMessageOwner: false,
            isRead: false
        ),
        ChatMessageModel(
            id: 3,
            senderId: 0,
            type: .text,
            content: "좀 애매하긴 해",
            metaData: nil,
            createdAt: "오전 7:30",
            isFirstChat: false,
            isMessageOwner: false,
            isRead: true
        ),
        ChatMessageModel(
            id: 4,
            senderId: 0,
            type: .text,
            content: "?",
            metaData: nil,
            createdAt: "오전 7:30",
            isFirstChat: false,
            isMessageOwner: true,
            isRead: true
        ),
        ChatMessageModel(
            id: 5,
            senderId: 0,
            type: .text,
            content: "뭐야 가세요;; 뭐야 가세요;; 뭐야 가세요;; 뭐야 가세요;; 뭐야 가세요;; 뭐야 가세요;; 뭐야 가세요;; 뭐야 가세요;; 뭐야 가세요;; 뭐야 가세요;; 뭐야 가세요;; 뭐야 가세요;;",
            metaData: nil,
            createdAt: "오전 7:30",
            isFirstChat: false,
            isMessageOwner: true,
            isRead: true
        ),
        ChatMessageModel(
            id: 6,
            senderId: 3,
            type: .date,
            content: nil,
            metaData: .date(
                DateMeta(type: .date, date: "2025년 4월 31일")
            ),
            createdAt: "오전 7:30",
            isFirstChat: false,
            isMessageOwner: false,
            isRead: true
        ),
        ChatMessageModel(
            id: 7,
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
            isMessageOwner: false,
            isRead: true
        ),
        ChatMessageModel(
            id: 8,
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
            isFirstChat: false,
            isMessageOwner: true,
            isRead: true
        )
    ]
}
