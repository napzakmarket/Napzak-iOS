//
//  ProductService.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/28/25.
//

import Moya

protocol ProductServiceProtocol {
    func fetchSellProducts(
        storeOwnerId: Int,
        sort: String?,
        isOnSale: Bool?,
        isUnopened: Bool?,
        genreId: Int?,
        cursor: String?
    ) async -> Result<(products: [MarketProductItemDTO], nextCursor: String?, count: Int), NetworkError>
    
    func fetchBuyProducts(
        storeOwnerId: Int,
        sort: String?,
        isOnSale: Bool?,
        genreId: Int?,
        cursor: String?
    ) async -> Result<(products: [MarketProductBuyItemDTO], nextCursor: String?, count: Int), NetworkError>
}

final class ProductService: BaseService, ProductServiceProtocol {
    private let provider = MoyaProvider<ProductAPI>()
    
    func fetchSellProducts(
        storeOwnerId: Int,
        sort: String? = "RECENT",
        isOnSale: Bool? = false,
        isUnopened: Bool? = false,
        genreId: Int? = nil,
        cursor: String? = nil
    ) async -> Result<(products: [MarketProductItemDTO], nextCursor: String?, count: Int), NetworkError> {
        
        let result: Result<BaseResponseDTO<MarketProductListResponseDTO>, NetworkError> = await request(
            provider,
            ProductAPI.getSellProducts(
                storeOwnerId: storeOwnerId,
                sort: sort,
                isOnSale: isOnSale,
                isUnopened: isUnopened,
                genreId: genreId,
                cursor: cursor
            )
        )
        
        return result.map { response in
            guard let data = response.data else {
                return (products: [], nextCursor: nil, count: 0)
            }
            
            return (
                products: data.productSellList,
                nextCursor: data.nextCursor,
                count: data.productCount
            )
        }
    }
    
    func fetchBuyProducts(
        storeOwnerId: Int,
        sort: String? = "RECENT",
        isOnSale: Bool? = false,
        genreId: Int? = nil,
        cursor: String? = nil
    ) async -> Result<(products: [MarketProductBuyItemDTO], nextCursor: String?, count: Int), NetworkError> {
        
        let result: Result<BaseResponseDTO<MarketProductBuyListResponseDTO>, NetworkError> = await request(
            provider,
            ProductAPI.getBuyProducts(
                storeOwnerId: storeOwnerId,
                sort: sort,
                isOnSale: isOnSale,
                genreId: genreId,
                cursor: cursor
            )
        )
        
        return result.map { response in
            guard let data = response.data else {
                return (products: [], nextCursor: nil, count: 0)
            }
            
            return (
                products: data.productBuyList,
                nextCursor: data.nextCursor,
                count: data.productCount
            )
        }
    }
}
