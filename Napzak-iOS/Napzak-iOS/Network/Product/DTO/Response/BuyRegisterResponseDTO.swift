//
//  BuyRegisterResponseDTO.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/5/25.
//

typealias BuyRegisterResponseDTO = BaseResponseDTO<BuyRegisterResponseData>

struct BuyRegisterResponseData: Decodable {
    let productId: Int
    let productPhotoList: [BuyRegisterResponsePhotoList]
    let genreId: Int
    let title, description: String
    let price: Int
    let isPriceNegotiable: Bool
    let createdAt: String
    let updatedAt: String?
}

struct BuyRegisterResponsePhotoList: Decodable {
    let photoId: Int
    let photoUrl: String
    let sequence: Int
}
