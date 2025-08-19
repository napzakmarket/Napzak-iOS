//
//  PresignedService.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/28/25.
//

import Foundation

import Moya

protocol PresignedServiceProtocol {
    func getProductPresignedURL(imageNameList: [String]) async -> Result<PresignedProductResponseDTO, NetworkError>
    func getStorePresignedURL(imageNameList: [String]) async -> Result<PresignedStoreResponseDTO, NetworkError>
    func getChatPresignedURL(imageNameList: [String]) async -> Result<PresignedChatResponseDTO, NetworkError>
    func putPresignedURL(url: String, imageData: Data) async -> Result<Void, NetworkError>
}

final class PresignedService: BaseService, PresignedServiceProtocol {
    
    let provider = MoyaProvider<PresignedAPI>.init(plugins: [MoyaPlugin()])

    func getProductPresignedURL(imageNameList: [String]) async -> Result<PresignedProductResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getProductPresignedURL(imageNameList: imageNameList))
    }

    func getStorePresignedURL(imageNameList: [String]) async -> Result<PresignedStoreResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getStorePresignedURL(imageNameList: imageNameList))
    }
    
    func getChatPresignedURL(imageNameList: [String]) async -> Result<PresignedChatResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getChatPresignedURL(imageNameList: imageNameList))
    }

    func putPresignedURL(url: String, imageData: Data) async -> Result<Void, NetworkError> {
        return await requestVoid(provider, .putPresignedURL(url: url, imageData: imageData))
    }
    
}
