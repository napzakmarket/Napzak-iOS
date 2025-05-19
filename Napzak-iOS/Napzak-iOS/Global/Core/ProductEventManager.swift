//
//  ProductEventManager.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 5/19/25.
//

import Combine

final class ProductEventManager {
    static let shared = ProductEventManager()
    
    private init() {}

    let productChanged = PassthroughSubject<Void, Never>()
}
