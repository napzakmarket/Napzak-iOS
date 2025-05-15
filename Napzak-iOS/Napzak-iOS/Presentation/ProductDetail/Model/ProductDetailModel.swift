//
//  ProductDetailModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 5/6/25.
//

struct ProductDetailModel {
    var isInterested: Bool
    var productDetail: ProductDetailInfo
    var productPhotoList: [ProductPhotoInfo]
    var storeInfo: StoreInfo
}

struct ProductDetailInfo: Identifiable {
    let id: Int
    let tradeType: TradeType
    let genreName: String
    let productName: String
    let price: Int
    let uploadTime: String
    var interestCount: Int
    let description: String
    let productCondition: ProductCondition?
    let standardDeliveryFee: Int
    let halfDeliveryFee: Int
    let isDeliveryIncluded: Bool
    let isPriceNegotiable: Bool
    var tradeStatus: TradeStatus
    let isOwnedByCurrentUser: Bool
    let chatCount: Int
    
    //MARK: - Init
    
    ///default init
    init(
        id: Int,
        tradeType: TradeType,
        genreName: String,
        productName: String,
        price: Int,
        uploadTime: String,
        interestCount: Int,
        description: String,
        productCondition: ProductCondition?,
        standardDeliveryFee: Int,
        halfDeliveryFee: Int,
        isDeliveryIncluded: Bool,
        isPriceNegotiable: Bool,
        tradeStatus: TradeStatus,
        isOwnedByCurrentUser: Bool,
        chatCount: Int
    ) {
        self.id = id
        self.tradeType = tradeType
        self.genreName = genreName
        self.productName = productName
        self.price = price
        self.uploadTime = uploadTime
        self.interestCount = interestCount
        self.description = description
        self.productCondition = productCondition
        self.standardDeliveryFee = standardDeliveryFee
        self.halfDeliveryFee = halfDeliveryFee
        self.isDeliveryIncluded = isDeliveryIncluded
        self.isPriceNegotiable = isPriceNegotiable
        self.tradeStatus = tradeStatus
        self.isOwnedByCurrentUser = isOwnedByCurrentUser
        self.chatCount = chatCount
    }
    
    ///init for decoding
    init(dto: ProductDetailInfoDTO) {
        self.id = dto.productId
        self.tradeType = dto.tradeType
        self.genreName = dto.genreName
        self.productName = dto.productName
        self.price = dto.price
        self.uploadTime = dto.uploadTime
        self.interestCount = dto.interestCount
        self.description = dto.description
        self.productCondition = dto.productCondition
        self.standardDeliveryFee = dto.standardDeliveryFee
        self.halfDeliveryFee = dto.halfDeliveryFee
        self.isDeliveryIncluded = dto.isDeliveryIncluded
        self.isPriceNegotiable = dto.isPriceNegotiable
        self.tradeStatus = dto.tradeStatus
        self.isOwnedByCurrentUser = dto.isOwnedByCurrentUser
        self.chatCount = dto.chatCount
    }
}

struct ProductPhotoInfo: Identifiable {
    let id: Int
    let photoUrl: String
    let sequence: Int
    
    //MARK: - Init
    
    ///default init
    init(id: Int, photoUrl: String, sequence: Int) {
        self.id = id
        self.photoUrl = photoUrl
        self.sequence = sequence
    }
    
    ///init for decoding
    init(dto: PhotoInfoDTO) {
        self.id = dto.photoId
        self.photoUrl = dto.photoUrl
        self.sequence = dto.sequence
    }
}

struct StoreInfo: Identifiable {
    let id: Int
    let storePhoto: String
    let nickname: String
    let totalSellCount: Int
    let totalBuyCount: Int
    
    //MARK: - Init
    
    ///default init
    init(id: Int, storePhoto: String, nickname: String, totalSellCount: Int, totalBuyCount: Int) {
        self.id = id
        self.storePhoto = storePhoto
        self.nickname = nickname
        self.totalSellCount = totalSellCount
        self.totalBuyCount = totalBuyCount
    }
    
    ///init for decoding
    init(dto: StoreInfoDTO) {
        self.id = dto.userId
        self.storePhoto = dto.storePhoto
        self.nickname = dto.nickname
        self.totalSellCount = dto.totalSellCount
        self.totalBuyCount = dto.totalBuyCount
    }
}
