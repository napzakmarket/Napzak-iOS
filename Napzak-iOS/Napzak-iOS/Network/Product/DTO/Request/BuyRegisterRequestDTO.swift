//
//  BuyRegisterRequestDTO.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/5/25.
//

import Foundation

struct BuyRegisterRequestDTO: Encodable {
    let productPhotoList: [BuyRegisterRequestPhotoList]
    let genreId: Int
    let title, description: String
    let price: Int
    let isPriceNegotiable: Bool
}

struct BuyRegisterRequestPhotoList: Encodable {
    let photoUrl: String
    let sequence: Int
}
