//
//  LikeViewModel.swift
//  Napzak-iOS
//
//  Created by 어진 on 6/29/25.
//

import Foundation

final class LikeViewModel: ObservableObject {
        
    @Published var sellProducts: [ProductItemModel] = []
    @Published var buyProducts: [ProductItemModel] = []
    @Published var showToast: Bool = false
    @Published var toastMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var temporarilyRemovedProducts: Set<Int> = []
    
    private let productService: ProductServiceProtocol
    private let interestService: InterestServiceProtocol
        
    init(
        productService: ProductServiceProtocol = ProductService(),
        interestService: InterestServiceProtocol = InterestService()
    ) {
        self.productService = productService
        self.interestService = interestService
    }
        
    func loadLikedProducts() {
        isLoading = true
        errorMessage = nil
        
        cleanupTemporarilyRemovedProducts()
        
        Task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask { [weak self] in
                    await self?.loadSellProducts()
                }
                
                group.addTask { [weak self] in
                    await self?.loadBuyProducts()
                }
            }
            
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
    
    func updateProducts() {
        cleanupTemporarilyRemovedProducts()
        loadLikedProducts()
    }
    
    func toggleLike(for productId: Int) {
       let isCurrentlyLiked = !temporarilyRemovedProducts.contains(productId)
       
       if isCurrentlyLiked {
           temporarilyRemovedProducts.insert(productId)
           updateProductLikeStatus(productId: productId, isLiked: false)
           
           Task {
               let result = await interestService.deleteInterest(productId: productId)
               await MainActor.run {
                   switch result {
                   case .success: break
                   case .failure(let error):
                       self.temporarilyRemovedProducts.remove(productId)
                       self.updateProductLikeStatus(productId: productId, isLiked: true)
                       self.errorMessage = error.localizedDescription
                   }
               }
           }
       } else {
           temporarilyRemovedProducts.remove(productId)
           updateProductLikeStatus(productId: productId, isLiked: true)
           
           showToast = true
           
           DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
               self.showToast = false
           }
           
           Task {
               let result = await interestService.postInterest(productId: productId)
               await MainActor.run {
                   switch result {
                   case .success: break
                   case .failure(let error):
                       self.temporarilyRemovedProducts.insert(productId)
                       self.updateProductLikeStatus(productId: productId, isLiked: false)
                       self.errorMessage = error.localizedDescription
                   }
               }
           }
       }
    }
    
    func isProductLiked(productId: Int) -> Bool {
        return !temporarilyRemovedProducts.contains(productId)
    }
        
    private func loadSellProducts() async {
        let result = await productService.getLikedSellProducts()
        
        await MainActor.run {
            switch result {
            case .success(let response):
                self.sellProducts = response.interestedSellProductList.map {
                    var product = $0.toProductItemModel()
                    product.isInterested = !self.temporarilyRemovedProducts.contains(product.id)
                    return product
                }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    private func loadBuyProducts() async {
        let result = await productService.getLikedBuyProducts()
        
        await MainActor.run {
            switch result {
            case .success(let response):
                self.buyProducts = response.interestedBuyProductList.map {
                    var product = $0.toProductItemModel()
                    product.isInterested = !self.temporarilyRemovedProducts.contains(product.id)
                    return product
                }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    private func cleanupTemporarilyRemovedProducts() {
        if temporarilyRemovedProducts.isEmpty { return }
        
        let removedIds = temporarilyRemovedProducts
        
        sellProducts.removeAll { product in
            removedIds.contains(product.id)
        }
        
        buyProducts.removeAll { product in
            removedIds.contains(product.id)
        }
        
        temporarilyRemovedProducts.removeAll()
    }
    
    private func updateProductLikeStatus(productId: Int, isLiked: Bool) {
        if let sellIndex = sellProducts.firstIndex(where: { $0.id == productId }) {
            sellProducts[sellIndex].isInterested = isLiked
        }
        
        if let buyIndex = buyProducts.firstIndex(where: { $0.id == productId }) {
            buyProducts[buyIndex].isInterested = isLiked
        }
    }
    
    private func showToastMessage(_ message: String) {
        toastMessage = message
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showToast = false
        }
    }
}
