//
//  ProductDetailViewModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 5/6/25.
//

import SwiftUI

import os

@MainActor
final class ProductDetailViewModel: ObservableObject {
    
    //MARK: - Property Wrappers

    @Published var product = ProductDetailModel(
        isInterested: false,
        productDetail: ProductDetailInfo(
            id: 0,
            tradeType: .buy,
            genreName: "",
            productName: "",
            price: 0,
            uploadTime: "",
            interestCount: 0,
            description: "",
            productCondition: nil,
            standardDeliveryFee: 0,
            halfDeliveryFee: 0,
            isDeliveryIncluded: false,
            isPriceNegotiable: false,
            tradeStatus: .beforeTrade,
            isOwnedByCurrentUser: false,
            chatCount: 0
        ),
        productPhotoList: [ProductPhotoInfo(id: 0, photoUrl: "", photoSequence: 0)],
        storeInfo: StoreInfo(id: 0, storePhoto: "", nickname: "", totalSellCount: 0, totalBuyCount: 0)
    )
    
    @Published var showToast: Bool = false
    
    //MARK: - Properties
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "ProductDetail")

    //MARK: - Init
    
    init(productId: Int) {
        Task {
            await fetchProduct(id: productId)
        }
    }
}

extension ProductDetailViewModel {
    func fetchProduct(id: Int) async {
        let result = await NetworkService.shared.productService.getProductDetailInfo(productId: id)
        
        switch result {
        case .success(let response):
            guard let data = response.data else {
                logger.error("getSellProduct: No data received")
                return
            }
            
            self.product.isInterested = data.isInterested
            self.product.productDetail = ProductDetailInfo(dto: data.productDetail)
            self.product.productPhotoList = data.productPhotoList.map { ProductPhotoInfo(dto: $0) }
            self.product.storeInfo = StoreInfo(dto: data.storeInfo)
            
        case .failure(let error):
            logger.error("getSellProduct failed: \(error.localizedDescription)")
        }
    }
    
    func toggleInterestState() {
        //TODO: - 좋아요 API 연결

        Task {
            product.isInterested.toggle()

            if product.isInterested {
                showToast = true
                try? await Task.sleep(for: .seconds(2))
                showToast = false
            }
        }
    }
}
