//
//  LikeViewModel.swift
//  Napzak-iOS
//
//  Created by 어진 on 6/29/25.
//

import Foundation
import Combine

final class LikeViewModel: ObservableObject {
        
    @Published var sellProducts: [ProductItemModel] = []
    @Published var buyProducts: [ProductItemModel] = []
    @Published var showToast: Bool = false
    @Published var toastMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // 찜 해제된 상품들을 임시 저장 (새로고침 시 제거)
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
        
        // 새로고침 시 임시 제거된 상품들을 실제로 제거
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
        // 탭 전환 시 임시 제거된 상품들을 실제로 제거
        cleanupTemporarilyRemovedProducts()
        loadLikedProducts()
    }
    
    func toggleLike(for productId: Int) {
        // 현재 상품의 찜 상태 확인
        let isCurrentlyLiked = !temporarilyRemovedProducts.contains(productId)
        
        if isCurrentlyLiked {
            // 찜 해제 - 임시 제거 상태로 마킹
            temporarilyRemovedProducts.insert(productId)
            updateProductLikeStatus(productId: productId, isLiked: false)
            
            // 서버에 찜 해제 요청
            Task {
                let result = await interestService.deleteInterest(productId: productId)
                await MainActor.run {
                    switch result {
                    case .success:
                        print("서버에서 찜 해제 성공: productId=\(productId)")
                    case .failure(let error):
                        // 서버 요청 실패 시 롤백
                        self.temporarilyRemovedProducts.remove(productId)
                        self.updateProductLikeStatus(productId: productId, isLiked: true)
                        self.errorMessage = error.localizedDescription
                        self.showToastMessage("찜 해제에 실패했습니다.")
                    }
                }
            }
        } else {
            // 찜 재활성화 - 임시 제거 상태에서 복구
            temporarilyRemovedProducts.remove(productId)
            updateProductLikeStatus(productId: productId, isLiked: true)
            showToastMessage("찜한 상품에 추가되었어요!")
            
            // 서버에 찜 추가 요청
            Task {
                let result = await interestService.postInterest(productId: productId)
                await MainActor.run {
                    switch result {
                    case .success:
                        print("서버에서 찜 추가 성공: productId=\(productId)")
                    case .failure(let error):
                        // 서버 요청 실패 시 롤백
                        self.temporarilyRemovedProducts.insert(productId)
                        self.updateProductLikeStatus(productId: productId, isLiked: false)
                        self.errorMessage = error.localizedDescription
                        self.showToastMessage("찜 추가에 실패했습니다.")
                    }
                }
            }
        }
    }
    
    func refreshData() {
        loadLikedProducts()
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
                    // 임시 제거된 상품은 찜 해제 상태로 표시
                    product.isInterested = !self.temporarilyRemovedProducts.contains(product.id)
                    return product
                }
                print("찜한 팔아요 상품 로드 성공: \(self.sellProducts.count)개")
            case .failure(let error):
                print("찜한 팔아요 상품 로드 실패: \(error)")
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
                    // 임시 제거된 상품은 찜 해제 상태로 표시
                    product.isInterested = !self.temporarilyRemovedProducts.contains(product.id)
                    return product
                }
                print("찜한 구해요 상품 로드 성공: \(self.buyProducts.count)개")
            case .failure(let error):
                print("찜한 구해요 상품 로드 실패: \(error)")
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    // 임시 제거된 상품들을 실제 리스트에서 제거
    private func cleanupTemporarilyRemovedProducts() {
        if temporarilyRemovedProducts.isEmpty { return }
        
        let removedIds = temporarilyRemovedProducts
        
        // 팔아요 상품에서 제거
        sellProducts.removeAll { product in
            removedIds.contains(product.id)
        }
        
        // 구해요 상품에서 제거
        buyProducts.removeAll { product in
            removedIds.contains(product.id)
        }
        
        print("임시 제거된 상품들 정리 완료: \(removedIds)")
        temporarilyRemovedProducts.removeAll()
    }
    
    // 특정 상품의 찜 상태 업데이트
    private func updateProductLikeStatus(productId: Int, isLiked: Bool) {
        // 팔아요 상품 업데이트
        if let sellIndex = sellProducts.firstIndex(where: { $0.id == productId }) {
            sellProducts[sellIndex].isInterested = isLiked
            print("팔아요 상품 찜 상태 업데이트: productId=\(productId), isInterested=\(isLiked)")
        }
        
        // 구해요 상품 업데이트
        if let buyIndex = buyProducts.firstIndex(where: { $0.id == productId }) {
            buyProducts[buyIndex].isInterested = isLiked
            print("구해요 상품 찜 상태 업데이트: productId=\(productId), isInterested=\(isLiked)")
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
