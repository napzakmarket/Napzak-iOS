//
//  PresignedService.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/28/25.
//

import Foundation

import Moya

protocol PresignedServiceProtocol {
    func getPresignedURL(imageNameList: [String]) async -> Result<PresignedProductResponseDTO, NetworkError>
    func putPresignedURL(url: String, imageData: Data) async -> Result<Void, NetworkError>
}

final class PresignedService: BaseService, PresignedServiceProtocol {
    
    let provider = MoyaProvider<PresignedAPI>.init(plugins: [MoyaPlugin()])

    func getPresignedURL(imageNameList: [String]) async -> Result<PresignedProductResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getPresignedProductURL(imageNameList: imageNameList))
    }

    func putPresignedURL(url: String, imageData: Data) async -> Result<Void, NetworkError> {
        return await requestVoid(provider, .putPresignedProductURL(url: url, imageData: imageData))
    }
    
}
