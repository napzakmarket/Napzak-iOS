//
//  ProductItemModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/16/25.
//

struct ProductItemModel: Identifiable {
    ///상품 목록 아이템 모델 구조체

    let id: Int
    let genreName: String
    let productName: String
    let photo: String?
    let price: Int
    let uploadTime: String
    var isInterested: Bool
    let tradeType: TradeType
    let tradeStatus: TradeStatus
    let isPriceNegotiable: Bool?
    let isOwnedByCurrentUser: Bool
    let interestCount: Int
    let chatCount: Int
    
    //MARK: - Init

    ///default init
    init(
        id: Int,
        genreName: String,
        productName: String,
        photo: String,
        price: Int,
        uploadTime: String,
        isInterested: Bool,
        tradeType: TradeType,
        tradeStatus: TradeStatus,
        isPriceNegotiable: Bool?,
        isOwnedByCurrentUser: Bool,
        interestCount: Int,
        chatCount: Int
    ) {
        self.id = id
        self.genreName = genreName
        self.productName = productName
        self.photo = photo
        self.price = price
        self.uploadTime = uploadTime
        self.isInterested = isInterested
        self.tradeType = tradeType
        self.tradeStatus = tradeStatus
        self.isPriceNegotiable = isPriceNegotiable
        self.isOwnedByCurrentUser = isOwnedByCurrentUser
        self.interestCount = interestCount
        self.chatCount = chatCount
    }
    
    ///init for decoding
    init(dto: ProductDTO) {
        self.id = dto.productId
        self.genreName = dto.genreName
        self.productName = dto.productName
        self.photo = dto.photo ?? ""
        self.price = dto.price
        self.uploadTime = dto.uploadTime
        self.isInterested = dto.isInterested
        self.tradeType = dto.tradeType
        self.tradeStatus = dto.tradeStatus
        self.isPriceNegotiable = dto.isPriceNegotiable
        self.isOwnedByCurrentUser = dto.isOwnedByCurrentUser
        self.interestCount = dto.interestCount
        self.chatCount = dto.chatCount
    }
}

extension ProductItemModel {
    init(dto: ProductWithCountDTO) {
        self.id = dto.productId
        self.genreName = dto.genreName
        self.productName = dto.productName
        self.photo = dto.photo
        self.price = dto.price
        self.uploadTime = dto.uploadTime
        self.isInterested = dto.isInterested
        self.tradeType = dto.tradeType
        self.tradeStatus = dto.tradeStatus
        self.isPriceNegotiable = dto.isPriceNegotiable
        self.isOwnedByCurrentUser = dto.isOwnedByCurrentUser
        self.interestCount = dto.interestCount
        self.chatCount = dto.chatCount
    }
}

extension ProductItemModel {
    static let dummyProducts: [ProductItemModel] = [
        ProductItemModel(
            id: 1,
            genreName: "산리오",
            productName: "딸기 마이멜로디 마스코트 인형",
            photo: "https://example.com/photo1.jpg",
            price: 35000,
            uploadTime: "3시간 전",
            isInterested: true,
            tradeType: .buy,
            tradeStatus: .beforeTrade,
            isPriceNegotiable: true,
            isOwnedByCurrentUser: false,
            interestCount: 30,
            chatCount: 10
        ),
        ProductItemModel(
            id: 2,
            genreName: "디즈니",
            productName: "미키마우스 한정판 피규어",
            photo: "https://example.com/photo2.jpg",
            price: 50000,
            uploadTime: "1일 전",
            isInterested: false,
            tradeType: .sell,
            tradeStatus: .beforeTrade,
            isPriceNegotiable: nil,
            isOwnedByCurrentUser: false,
            interestCount: 30,
            chatCount: 10
        ),
        ProductItemModel(
            id: 3,
            genreName: "포켓몬",
            productName: "피카츄 봉제인형",
            photo: "https://example.com/photo3.jpg",
            price: 27000,
            uploadTime: "2일 전",
            isInterested: true,
            tradeType: .sell,
            tradeStatus: .reserved,
            isPriceNegotiable: nil,
            isOwnedByCurrentUser: true,
            interestCount: 30,
            chatCount: 10
        ),
        ProductItemModel(
            id: 4,
            genreName: "마블",
            productName: "아이언맨 액션 피규어",
            photo: "https://example.com/photo4.jpg",
            price: 60000,
            uploadTime: "5시간 전",
            isInterested: false,
            tradeType: .sell,
            tradeStatus: .completed,
            isPriceNegotiable: nil,
            isOwnedByCurrentUser: false,
            interestCount: 30,
            chatCount: 10
        ),
        ProductItemModel(
            id: 5,
            genreName: "DC 코믹스",
            productName: "배트맨 한정판 마스크",
            photo: "https://example.com/photo5.jpg",
            price: 80000,
            uploadTime: "1시간 전",
            isInterested: true,
            tradeType: .buy,
            tradeStatus: .completed,
            isPriceNegotiable: nil,
            isOwnedByCurrentUser: false,
            interestCount: 30,
            chatCount: 10
        ),
        ProductItemModel(
            id: 6,
            genreName: "지브리",
            productName: "토토로 인형 세트",
            photo: "https://example.com/photo6.jpg",
            price: 45000,
            uploadTime: "3일 전",
            isInterested: false,
            tradeType: .sell,
            tradeStatus: .beforeTrade,
            isPriceNegotiable: nil,
            isOwnedByCurrentUser: true,
            interestCount: 30,
            chatCount: 10
        ),
        ProductItemModel(
            id: 7,
            genreName: "스타워즈",
            productName: "다스베이더 광선검",
            photo: "https://example.com/photo7.jpg",
            price: 70000,
            uploadTime: "30분 전",
            isInterested: true,
            tradeType: .sell,
            tradeStatus: .beforeTrade,
            isPriceNegotiable: nil,
            isOwnedByCurrentUser: false,
            interestCount: 30,
            chatCount: 10
        )
    ]
}
