//
//  ProductService.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/28/25.
//

import Moya

protocol ProductServiceProtocol {
    func postSellRegister(sellRegisterProduct: SellRegisterRequestDTO) async -> Result<SellRegisterResponseDTO, NetworkError>
    func postBuyRegister(buyRegisterProduct: BuyRegisterRequestDTO) async -> Result<BuyRegisterResponseDTO, NetworkError>
    func getSellProduct(productFetchOption: ProductFetchOption) async -> Result<SellProductResponseDTO, NetworkError>
    func getBuyProduct(productFetchOption: ProductFetchOption) async -> Result<BuyProductResponseDTO, NetworkError>
    func fetchSellProducts(
        storeOwnerId: Int,
        sort: String?,
        isOnSale: Bool?,
        isUnopened: Bool?,
        genreId: Int?,
        cursor: String?
    ) async -> Result<MarketProductListResponseDTO, NetworkError>
    func fetchBuyProducts(
        storeOwnerId: Int,
        sort: String?,
        isOnSale: Bool?,
        genreId: Int?,
        cursor: String?
    ) async -> Result<MarketProductBuyListResponseDTO, NetworkError>
    func getProductDetailInfo(productId: Int) async -> Result<ProductDetailResponseDTO, NetworkError>
    func getSearchRecommendation() async -> Result<SearchRecommendationResponseDTO, NetworkError>
    func patchTradeStatus(productId: Int, requestBody: ChangeTradeStatusRequestDTO) async -> Result<Void, NetworkError>
    func deleteProduct(productId: Int) async -> Result<Void, NetworkError>
}

final class ProductService: BaseService, ProductServiceProtocol {
    private let provider = MoyaProvider<ProductAPI>(plugins: [MoyaPlugin()])

    func postSellRegister(sellRegisterProduct: SellRegisterRequestDTO) async -> Result<SellRegisterResponseDTO, NetworkError> {
        return await requestDecodable(provider, ProductAPI.sellRegister(registerItem: sellRegisterProduct))
    }

    func postBuyRegister(buyRegisterProduct: BuyRegisterRequestDTO) async -> Result<BuyRegisterResponseDTO, NetworkError> {
        return await requestDecodable(provider, ProductAPI.buyRegister(registerItem: buyRegisterProduct))
    }
    
    func getSellProduct(productFetchOption: ProductFetchOption) async -> Result<SellProductResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getSellProduct(productFetchOption: productFetchOption))
    }
    
    func getBuyProduct(productFetchOption: ProductFetchOption) async -> Result<BuyProductResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getBuyProduct(productFetchOption: productFetchOption))
    }
    
    func fetchSellProducts(
        storeOwnerId: Int,
        sort: String? = "RECENT",
        isOnSale: Bool? = false,
        isUnopened: Bool? = false,
        genreId: Int? = nil,
        cursor: String? = nil
    ) async -> Result<MarketProductListResponseDTO, NetworkError> {
        
        let result: Result<BaseMarketProductListResponseDTO, NetworkError> = await requestDecodable(
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
                // 빈 응답 객체 생성
                return MarketProductListResponseDTO(productCount: 0, productSellList: [], nextCursor: nil)
            }
            
            return data
        }
    }
    
    func fetchBuyProducts(
        storeOwnerId: Int,
        sort: String? = "RECENT",
        isOnSale: Bool? = false,
        genreId: Int? = nil,
        cursor: String? = nil
    ) async -> Result<MarketProductBuyListResponseDTO, NetworkError> {
        
        let result: Result<BaseMarketProductBuyListResponseDTO, NetworkError> = await requestDecodable(
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
                // 빈 응답 객체 생성
                return MarketProductBuyListResponseDTO(productCount: 0, productBuyList: [], nextCursor: nil)
            }
            
            return data
        }
    }
    
    func getProductDetailInfo(productId: Int) async -> Result<ProductDetailResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getProductDetailInfo(productId: productId))
    }
    
    func getSearchRecommendation() async -> Result<SearchRecommendationResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getSearchRecommendation)
    }
    
    func patchTradeStatus(productId: Int, requestBody: ChangeTradeStatusRequestDTO) async -> Result<Void, NetworkError> {
        return await requestVoid(provider, .patchTradeStatus(productId: productId, body: requestBody))
    }

    func deleteProduct(productId: Int) async -> Result<Void, NetworkError> {
        return await requestVoid(provider, .deleteProduct(productId: productId))
    }
}
