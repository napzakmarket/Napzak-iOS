//
//  RegisterModel.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/29/25.
//

import SwiftUI

enum DeliveryType {
    case included
    case separate
}

struct RegisterModel {
    // Shared
    var title: String = ""
    var description: String = ""
    var price: String = ""
    var genre: String = ""
    var genreId: Int?
    
    // Sell
    var productCondition: String = ""
    var deliveryType: DeliveryType?
    var standardDeliveryFee: String = ""
    var halfDeliveryFee: String = ""
    
    // Buy
    var isPriceNegotiable: Bool = false
}
