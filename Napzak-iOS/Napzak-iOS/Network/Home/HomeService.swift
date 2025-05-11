//
//  HomeService.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/10/25.
//

import Foundation
import Moya

protocol HomeServiceProtocol {
    func getBannerList() async -> Result<BannerResponseDTO, NetworkError>
    func getHomeRecommendations() async -> Result<ProductItemResponseDTO, NetworkError>
    func getHomePopularSell() async -> Result<SellProductListResponseDTO, NetworkError>
    func getHomePopularBuy() async -> Result<BuyProductListResponseDTO, NetworkError>
}

final class HomeService: BaseService, HomeServiceProtocol {
    
    private let provider = MoyaProvider<HomeAPI>.init(plugins: [MoyaPlugin()])
    
    func getBannerList() async -> Result<BannerResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getBannerList)
    }
    
    func getHomeRecommendations() async -> Result<ProductItemResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getHomeRecommendations)
    }
    
    func getHomePopularSell() async -> Result<SellProductListResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getHomePopularSell)
    }
    
    func getHomePopularBuy() async -> Result<BuyProductListResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getHomePopularBuy)
    }
}
