//
//  EditProductResponseDTO.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 5/12/25.
//

typealias EditSellProductResponseDTO = BaseResponseDTO<SellRegisterResponseData>
typealias EditBuyProductResponseDTO = BaseResponseDTO<EditBuyProductDTO>

struct EditSellProductDTO: Decodable {
    let productId: Int
    let genreId: Int
    let genreName: String
    let title: String
    let description: String
    let productCondition: String
    let price: Int
    let isDeliveryIncluded: Bool
    let standardDeliveryFee: Int
    let halfDeliveryFee: Int
    let productPhotoList: [PhotoInfoDTO]
}

struct EditBuyProductDTO: Decodable {
    let productId: Int
    let genreId: Int
    let genreName: String
    let title: String
    let description: String
    let price: Int
    let isPriceNegotiable: Bool
    let productPhotoList: [PhotoInfoDTO]
}
