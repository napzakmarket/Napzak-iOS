//
//  ProductDetailViewModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 5/6/25.
//

import SwiftUI
import Combine
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
        productPhotoList: [ProductPhotoInfo(id: 0, photoUrl: "", sequence: 0)],
        storeInfo: StoreInfo(id: 0, storePhoto: "", nickname: "", totalSellCount: 0, totalBuyCount: 0)
    )
    
    @Published var showInterestToast: Bool = false
    @Published var showStatusToast = false

    @ObservedObject private var likeManager = ProductLikeManager.shared

    //MARK: - Properties
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "ProductDetail")
    private var cancellables = Set<AnyCancellable>()
    private let likeSubject = PassthroughSubject<(Int, Bool), Never>()
    
    private let interestService = NetworkService.shared.interestService
    let productId: Int
    let loadingManager = LoadingViewManager()
    private let mixpanelManager = MixpanelManager.shared

    //MARK: - Init
    
    init(productId: Int) {
        self.productId = productId
        setupLikeObserver()
        setupLikePublisher()
        
        Task {
            await fetchProduct(id: productId)
        }
    }
    
    private func setupLikeObserver() {
        Task {
            for await _ in likeManager.$updatedProductId.values {
                if let updatedId = likeManager.updatedProductId,
                   let newState = likeManager.newLikeState,
                   updatedId == productId {
                    
                    product.isInterested = newState
                    product.productDetail.interestCount += newState ? 1 : -1
                }
            }
        }
    }

}

extension ProductDetailViewModel {
    func fetchProduct(id: Int) async {
        loadingManager.startLoading()
        defer { loadingManager.stopLoading() }
        
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
        let newState = !product.isInterested
        
        likeManager.productLikeUpdated(
            productId: product.productDetail.id,
            isLiked: newState
        )
        
        MixpanelManager.shared.trackEvent(
            event: "Item Liked",
            properties: [
                "post_id": productId,
                "genre_name": product.productDetail.genreName,
                "tab": product.productDetail.tradeType.mixpanelName,
                "source": "item_detail",
                "action_type": newState ? "add" : "remove"
            ]
        )
        
        if newState {
            showInterestToast = true
            Task {
                try? await Task.sleep(for: .seconds(2))
                await MainActor.run {
                    showInterestToast = false
                }
            }
        }
            
        likeSubject.send((product.productDetail.id, newState)) 
    }
    
    private func setupLikePublisher() {
        likeSubject
            .throttle(for: .milliseconds(500), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] (productId, newState) in
                guard let self = self else { return }
                
                Task {
                    let result = newState ?
                    await self.interestService.postInterest(productId: productId) :
                    await self.interestService.deleteInterest(productId: productId)
                    
                    await MainActor.run {
                        if case .failure(let error) = result {
                            self.likeManager.productLikeUpdated(productId: productId, isLiked: !newState)
                            self.logger.error("toggleInterestState failed: \(error.errorDescription ?? "Unknown error")")
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func changeTradeStatus() async {
        let result = await NetworkService.shared.productService.patchTradeStatus(
            productId: product.productDetail.id,
            requestBody: ChangeTradeStatusRequestDTO(
                tradeStatus: product.productDetail.tradeStatus
            )
        )
        
        switch result {
        case .success:
            showStatusToast = true
            try? await Task.sleep(for: .seconds(1.5))
            showStatusToast = false
            ProductEventManager.shared.productChanged.send(())
            
            var status: String?
            let tradeStatus = product.productDetail.tradeStatus
            let tradeType = product.productDetail.tradeType
            var mixpanleStatus_label: String = "on_sale"
            
            if tradeStatus == .reserved {
                status = "in_progress"
                mixpanleStatus_label = "reserved"
            } else if tradeStatus == .completed {
                status = tradeType == .sell ? "sale_completed" : "payment_completed"
                mixpanleStatus_label = "completed"
            }
            
            mixpanelManager.trackEvent(
                event: "Item Status Updated",
                properties: [
                    "post_id": productId,
                    "genre_name": product.productDetail.genreName,
                    "tab": tradeType.mixpanelName,
                    "status_label": mixpanleStatus_label
                ]
            )
            
            guard let status else { return }
            mixpanelManager.trackEvent(event: "Changed Product_status", properties: ["product_id": productId,
                                                                                     "product_status": status])
        case .failure(let error):
            logger.error("getSellProduct failed: \(error.localizedDescription)")
        }
    }
    
    func deleteProduct() async {
        let result = await NetworkService.shared.productService.deleteProduct(
            productId: product.productDetail.id)
        
        switch result {
        case .success:
            ProductEventManager.shared.productChanged.send(())
            showStatusToast = true
            try? await Task.sleep(for: .seconds(1.5))
            showStatusToast = false
        case .failure(let error):
            logger.error("getSellProduct failed: \(error.localizedDescription)")
        }
    }
}
