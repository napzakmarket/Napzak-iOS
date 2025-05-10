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
}

final class ProductService: BaseService, ProductServiceProtocol {
    private let provider = MoyaProvider<ProductAPI>(plugins: [MoyaPlugin()])

    func postSellRegister(sellRegisterProduct: SellRegisterRequestDTO) async -> Result<SellRegisterResponseDTO, NetworkError> {
        return await requestDecodable(provider, ProductAPI.sellRegister(registerItem: sellRegisterProduct))
    }

    func postBuyRegister(buyRegisterProduct: BuyRegisterRequestDTO) async -> Result<BuyRegisterResponseDTO, NetworkError> {
        return await requestDecodable(provider, ProductAPI.buyRegister(registerItem: buyRegisterProduct))
    }
    
    func fetchSellProducts(
        storeOwnerId: Int,
        sort: String? = "RECENT",
        isOnSale: Bool? = false,
        isUnopened: Bool? = false,
        genreId: Int? = nil,
        cursor: String? = nil
    ) async -> Result<MarketProductListResponseDTO, NetworkError> {
        
        let result: Result<BaseResponseDTO<MarketProductListResponseDTO>, NetworkError> = await requestDecodable(
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
        
        let result: Result<BaseResponseDTO<MarketProductBuyListResponseDTO>, NetworkError> = await requestDecodable(
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
}
