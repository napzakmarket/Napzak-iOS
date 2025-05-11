//
//  RegisterModel.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/29/25.
//

import SwiftUI

struct RegisterModel {
    // Shared
    var images: [UIImage] = []
    var title: String = ""
    var description: String = ""
    var price: String = ""
    var genre: String = ""
    var genreId: Int?
    
    // Sell
    var productCondition: ProductCondition?
    var isDeliveryIncluded: Bool?
    var standardDeliveryFee: String = "0"
    var halfDeliveryFee: String = "0"
    
    // Buy
    var isPriceNegotiable: Bool = false
}
