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
    func getSellProductForSearch(searchWord: String, productFetchOption: ProductFetchOption) async -> Result<SellProductResponseDTO, NetworkError>
    func getBuyProductForSearch(searchWord: String, productFetchOption: ProductFetchOption) async -> Result<BuyProductResponseDTO, NetworkError>
    func getSellProductsForMarket(storeOwnerId: Int, productFetchOption: ProductFetchOption) async -> Result<SellProductResponseDTO, NetworkError>
    func getBuyProductsForMarket(storeOwnerId: Int, productFetchOption: ProductFetchOption) async -> Result<BuyProductResponseDTO, NetworkError>
    func getProductDetailInfo(productId: Int) async -> Result<ProductDetailResponseDTO, NetworkError>
    func getSearchRecommendation() async -> Result<SearchRecommendationResponseDTO, NetworkError>
    func patchTradeStatus(productId: Int, requestBody: ChangeTradeStatusRequestDTO) async -> Result<Void, NetworkError>
    func deleteProduct(productId: Int) async -> Result<Void, NetworkError>
    func getSellProductInfoForEdit(productId: Int) async -> Result<EditSellProductResponseDTO, NetworkError>
    func getBuyProductInfoForEdit(productId: Int) async -> Result<EditBuyProductResponseDTO, NetworkError>
    func putSellProduct(productId: Int, requestBody: SellRegisterRequestDTO) async -> Result<SellRegisterResponseDTO, NetworkError>
    func putBuyProduct(productId: Int, requestBody: BuyRegisterRequestDTO) async -> Result<BuyRegisterResponseDTO, NetworkError>
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
    
    func getSellProductForSearch(searchWord: String, productFetchOption: ProductFetchOption) async -> Result<SellProductResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getSellProductForSearch(searchWord: searchWord, productFetchOption: productFetchOption))
    }
    
    func getBuyProductForSearch(searchWord: String, productFetchOption: ProductFetchOption) async -> Result<BuyProductResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getBuyProductForSearch(searchWord: searchWord, productFetchOption: productFetchOption))
    }
    
    func getSellProductsForMarket(storeOwnerId: Int, productFetchOption: ProductFetchOption) async -> Result<SellProductResponseDTO, NetworkError> {
        
        return await requestDecodable(provider, .getSellProductsForMarket(storeOwnerId: storeOwnerId, productFetchOption: productFetchOption))
    }
    
    func getBuyProductsForMarket(storeOwnerId: Int, productFetchOption: ProductFetchOption) async -> Result<BuyProductResponseDTO, NetworkError> {
        
        return await requestDecodable(provider, .getBuyProductsForMarket(storeOwnerId: storeOwnerId, productFetchOption: productFetchOption))
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
    
    func getSellProductInfoForEdit(productId: Int) async -> Result<EditSellProductResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getSellProductInfoForEdit(productId: productId))
    }
    
    func getBuyProductInfoForEdit(productId: Int) async -> Result<EditBuyProductResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getBuyProductInfoForEdit(productId: productId))
    }
    
    func putSellProduct(productId: Int, requestBody: SellRegisterRequestDTO) async -> Result<SellRegisterResponseDTO, NetworkError> {
        return await requestDecodable(provider, .putSellProduct(productId: productId, requestBody: requestBody))
    }
    
    func putBuyProduct(productId: Int, requestBody: BuyRegisterRequestDTO) async -> Result<BuyRegisterResponseDTO, NetworkError> {
            return await requestDecodable(provider, .putBuyProduct(productId: productId, requestBody: requestBody))
    }
}
