//
//  RegisterService.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/5/25.
//

import Foundation

import Moya

protocol RegisterServiceProtocol {
    func postSellRegister(sellRegisterProduct: SellRegisterRequestDTO) async -> Result<SellRegisterResponseDTO, NetworkError>
    func postBuyRegister(buyRegisterProduct: BuyRegisterRequestDTO) async -> Result<BuyRegisterResponseDTO, NetworkError>
}

final class RegisterService: BaseService, RegisterServiceProtocol {

    let provider = MoyaProvider<RegisterAPI>.init(plugins: [MoyaPlugin()])

    func postSellRegister(sellRegisterProduct: SellRegisterRequestDTO) async -> Result<SellRegisterResponseDTO, NetworkError> {
        return await request(provider, .sellRegister(registerItem: sellRegisterProduct))
    }

    func postBuyRegister(buyRegisterProduct: BuyRegisterRequestDTO) async -> Result<BuyRegisterResponseDTO, NetworkError> {
        return await request(provider, .buyRegister(registerItem: buyRegisterProduct))
    }
    
}
