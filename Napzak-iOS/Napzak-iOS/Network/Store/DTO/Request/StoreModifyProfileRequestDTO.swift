//
//  StoreModifyProfileRequestDTO.swift
//  Napzak-iOS
//
//  Created by 어진 on 5/3/25.
//

import Foundation

struct StoreModifyProfileRequestDTO: Encodable {
    let storeCover: String?
    let storePhoto: String?
    let storeNickName: String?
    let storeDescription: String?
    let preferredGenreList: [Int]?
}
