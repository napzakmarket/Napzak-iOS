//
//  PhoneVerificationEntryPoint.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/27/26.
//

import Foundation

enum PhoneVerificationEntryPoint: Equatable {
    case homeModal
    case registerSell
    case registerBuy
    case chatPush(roomID: Int)
    case productDetailChat(productID: Int)
    case chatRoom(roomID: Int)
}
