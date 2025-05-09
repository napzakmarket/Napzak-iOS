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
}

final class ProductService: BaseService, ProductServiceProtocol {
   
    private let provider = MoyaProvider<ProductAPI>.init(plugins: [MoyaPlugin()])
    
    func postSellRegister(sellRegisterProduct: SellRegisterRequestDTO) async -> Result<SellRegisterResponseDTO, NetworkError> {
        return await requestDecodable(provider, .sellRegister(registerItem: sellRegisterProduct))
    }

    func postBuyRegister(buyRegisterProduct: BuyRegisterRequestDTO) async -> Result<BuyRegisterResponseDTO, NetworkError> {
        return await requestDecodable(provider, .buyRegister(registerItem: buyRegisterProduct))
    }
}
