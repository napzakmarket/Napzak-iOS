//
//  StoreService.swift
//  Napzak-iOS
//
//  Created by 어진 on 5/3/25.
//

import Moya

protocol StoreServiceProtocol {
    func getMyPageInfo() async -> Result<StoreResponseDTO, NetworkError>
    func getStoreDetail(storeId: Int) async -> Result<StoreDetailResponseDTO, NetworkError>
    func modifyProfile(request: StoreModifyProfileRequestDTO) async -> Result<StoreModifyProfileResponseDTO, NetworkError>
    func getTerms() async -> Result<TermsResponseDTO, NetworkError>
}

final class StoreService: BaseService, StoreServiceProtocol {
    
    private let provider = MoyaProvider<StoreAPI>.init(plugins: [MoyaPlugin()])
    
    func getMyPageInfo() async -> Result<StoreResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getMyPageInfo)
    }

    func getStoreDetail(storeId: Int) async -> Result<StoreDetailResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getStoreDetail(storeId: storeId))
    }

    func modifyProfile(request: StoreModifyProfileRequestDTO) async -> Result<StoreModifyProfileResponseDTO, NetworkError> {
        return await self.requestDecodable(provider, .modifyProfile(request: request))
    }
    
    func getTerms() async -> Result<TermsResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getTerms)
    }
}
