//
//  ProductDetailViewModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 5/6/25.
//

import SwiftUI

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

    //MARK: - Init
    
    init() {
        fetchProduct()
    }
}

extension ProductDetailViewModel {
    func fetchProduct() {
        product = ProductDetailModel(
            isInterested: true,
            productDetail: ProductDetailInfo(
                id: 1,
                tradeType: .buy,
                genreName: "사카모토 데이즈",
                productName: "사카모토데이즈 제일복권 라스트원상나구모 요이치 피규어",
                price: 150000,
                uploadTime: "방금",
                interestCount: 9,
                description: "은혼 긴토키 히지카타 룩업은혼 긴토키 히지카타 룩업은혼 긴토키 히지카타 룩업은혼 긴토키 히지카타 룩업은혼 긴토키 히지카타 룩업은혼 긴토키 히지카타 룩업은혼 긴토키 히지카타 룩업은혼 긴토키 히지카타 룩업은혼 긴토키 히지카타 룩업은혼 긴토키 히지카타 룩업은혼 긴토키 히지카타 룩업은혼 긴토키 히지카타 룩업은혼 긴토키 히지카타 룩업은혼 긴토키 히지카타 룩업은혼 긴토키 히지카타 룩업아아아은혼 긴토키 히지카타 룩업은혼 긴토키 히지카타 룩업은혼 긴토키 히지카타 룩업은혼 긴토키 히지카타 룩업은혼 긴토키 히지카타 룩업은혼 긴토키 히지카타 룩업은혼 긴토키 히지카타 룩업은혼 긴토키 히지카타 룩업은혼 긴토키 히지카타 룩업은혼 긴토키 히지카타 룩업은혼 긴토키 히지카타 룩업은혼 긴토키 히지카타 룩업은혼 긴토키 히지카타 룩업은혼 긴토키 히지카타 룩업은혼 긴토키 히지카타 룩업아아아카타",
                productCondition: .likeNew,
                standardDeliveryFee: 0,
                halfDeliveryFee: 3000,
                isDeliveryIncluded: false,
                isPriceNegotiable: true,
                tradeStatus: .completed,
                isOwnedByCurrentUser: true,
                chatCount: 34
            ),
            productPhotoList: [
                ProductPhotoInfo(
                    id: 1,
                    photoUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOrPQwOTaU_L8EIFpWzLjgiUHc3CcmGEq84A&s",
                    photoSequence: 1
                ),
                ProductPhotoInfo(
                    id: 2,
                    photoUrl: "https://napzak-dev-bucket.s3.ap-northeast-2.amazonaws.com/product/40.jpg",
                    photoSequence: 2
                ),
                ProductPhotoInfo(
                    id: 3,
                    photoUrl: "https://napzak-dev-bucket.s3.ap-northeast-2.amazonaws.com/product/40.jpg",
                    photoSequence: 3
                ),
                ProductPhotoInfo(
                    id: 4,
                    photoUrl: "https://napzak-dev-bucket.s3.ap-northeast-2.amazonaws.com/product/40.jpg",
                    photoSequence: 4
                ),
                ProductPhotoInfo(
                    id: 5,
                    photoUrl: "https://napzak-dev-bucket.s3.ap-northeast-2.amazonaws.com/product/40.jpg",
                    photoSequence: 5
                )
            ],
            storeInfo: StoreInfo(
                id: 1,
                storePhoto: "https://napzak-dev-bucket.s3.ap-northeast-2.amazonaws.com/store/img_profile_lg.png",
                nickname: "납작한 외계인",
                totalSellCount: 36,
                totalBuyCount: 10
            )
        )
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
