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
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
        
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
        loadLikedProducts()
    }
    
    func toggleLike(for productId: Int) {
        Task {
            let result = await interestService.deleteInterest(productId: productId)
            
            await MainActor.run {
                switch result {
                case .success:
                    self.removeProductFromList(productId: productId)
                    self.showToastMessage()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func refreshData() {
        loadLikedProducts()
    }
        
    private func loadSellProducts() async {
        let result = await productService.getLikedSellProducts()
        
        await MainActor.run {
            switch result {
            case .success(let response):
                self.sellProducts = response.interestedSellProductList.map { $0.toProductItemModel() }
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
                self.buyProducts = response.interestedBuyProductList.map { $0.toProductItemModel() }
                print("찜한 구해요 상품 로드 성공: \(self.buyProducts.count)개")
            case .failure(let error):
                print("찜한 구해요 상품 로드 실패: \(error)")
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    private func removeProductFromList(productId: Int) {
        // 팔아요 상품에서 제거
        if let sellIndex = sellProducts.firstIndex(where: { $0.id == productId }) {
            sellProducts.remove(at: sellIndex)
            print("팔아요 상품 목록에서 제거됨: productId=\(productId)")
            return
        }
        
        // 구해요 상품에서 제거
        if let buyIndex = buyProducts.firstIndex(where: { $0.id == productId }) {
            buyProducts.remove(at: buyIndex)
            print("구해요 상품 목록에서 제거됨: productId=\(productId)")
            return
        }
        
        print("제거할 상품을 찾을 수 없음: productId=\(productId)")
    }
    
    private func showToastMessage() {
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showToast = false
        }
    }
}
