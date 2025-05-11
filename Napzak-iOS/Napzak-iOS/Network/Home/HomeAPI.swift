//
//  HomeAPI.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/10/25.
//

import Moya

enum HomeAPI {
    case getBannerList
    case getHomeRecommendations
    case getHomePopularSell
    case getHomePopularBuy
}

extension HomeAPI: BaseTargetType {
    
    var headerType: HeaderType {
        return .accessTokenHeader
    }
    
    var path: String {
        switch self {
        case .getBannerList:
            return "banners/home"
        case .getHomeRecommendations:
            return "products/home/recommend"
        case .getHomePopularSell:
            return "products/home/sell"
        case .getHomePopularBuy:
            return "products/home/buy"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        return .requestPlain
    }
}
