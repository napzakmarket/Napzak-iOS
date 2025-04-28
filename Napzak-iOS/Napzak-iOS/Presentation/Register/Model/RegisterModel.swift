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
    
    // Sell
    var productCondition: String = ""
    var deliveryType: DeliveryType?
    var standardDeliveryFee: String = ""
    var halfDeliveryCharge: String = ""
    
    // Buy
    var suggestPrice: Bool = false
}
