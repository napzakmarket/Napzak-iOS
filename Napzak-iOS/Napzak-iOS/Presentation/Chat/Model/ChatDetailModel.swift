//
//  ChatDetailModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 6/30/25.
//

struct ChatDetailModel {
    var productInfo: ChatProductInfo
    var chatStoreInfo: ChatStoreInfo
}

struct ChatProductInfo {
    let productId: Int
    let photo: String
    let tradeType: TradeType
    let title: String
    let price: Int
    let isPriceNegotiable: Bool
    let genreName: String
    
    //MARK: - Init
    
    ///default init
    init(
        productId: Int,
        photo: String,
        tradeType: TradeType,
        title: String,
        price: Int,
        isPriceNegotiable: Bool,
        genreName: String
    ) {
        self.productId = productId
        self.photo = photo
        self.tradeType = tradeType
        self.title = title
        self.price = price
        self.isPriceNegotiable = isPriceNegotiable
        self.genreName = genreName
    }
    
    ///init for decoding
    init(dto: ChatProductInfoDTO) {
        self.productId = dto.productId
        self.photo = dto.photo
        self.tradeType = dto.tradeType
        self.title = dto.title
        self.price = dto.price
        self.isPriceNegotiable = dto.isPriceNegotiable
        self.genreName = dto.genreName
    }
}

struct ChatStoreInfo {
    let storeId: Int
    let nickname: String
    let isWithdrawn: Bool
    let storePhoto: String
    
    //MARK: - Init
    
    ///default init
    init(
        storeId: Int,
        nickname: String,
        isWithdrawn: Bool,
        storePhoto: String
    ) {
        self.storeId = storeId
        self.nickname = nickname
        self.isWithdrawn = isWithdrawn
        self.storePhoto = storePhoto
    }
    
    ///init for decoding
    init(dto: ChatStoreInfoDTO) {
        self.storeId = dto.storeId
        self.nickname = dto.nickname
        self.isWithdrawn = dto.isWithdrawn
        self.storePhoto = dto.storePhoto
    }
}
