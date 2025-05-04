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
}

final class RegisterService: BaseService, RegisterServiceProtocol {
    
    let provider = MoyaProvider<RegisterAPI>.init(plugins: [MoyaPlugin()])

    func postSellRegister(sellRegisterProduct: SellRegisterRequestDTO) async -> Result<SellRegisterResponseDTO, NetworkError> {
        return await request(provider, .sellRegister(registerItem: sellRegisterProduct))
    }

    
}
