//
//  ProductLikeManager.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/15/25.
//

import Foundation

final class ProductLikeManager: ObservableObject {
    static let shared = ProductLikeManager()
    
    @Published var updatedProductId: Int?
    @Published var newLikeState: Bool?
    
    private init() {}
    
    func productLikeUpdated(productId: Int, isLiked: Bool) {
        updatedProductId = productId
        newLikeState = isLiked
    }
    
    func reset() {
        updatedProductId = nil
        newLikeState = nil
    }
}
