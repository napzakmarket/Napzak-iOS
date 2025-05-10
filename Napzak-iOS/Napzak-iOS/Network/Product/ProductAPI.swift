//
//  ProductAPI.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/28/25.
//

import Moya

enum ProductAPI {
    case sellRegister(registerItem: SellRegisterRequestDTO)
    case buyRegister(registerItem: BuyRegisterRequestDTO)
    case getSellProduct(productFetchOption: ProductFetchOption)
    case getBuyProduct(productFetchOption: ProductFetchOption)
}

extension ProductAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        default:
            return .accessTokenHeader
        }
    }

    var path: String {
        switch self {
        case .sellRegister, .getSellProduct:
            return "products/sell"
        case .buyRegister, .getBuyProduct:
            return "products/buy"
        }
    }

    var method: Moya.Method {
        switch self {
        case .sellRegister, .buyRegister:
            return .post
        case .getSellProduct, .getBuyProduct:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .sellRegister(let registerItem):
            return .requestJSONEncodable(registerItem)
        case .buyRegister(let registerItem):
            return .requestJSONEncodable(registerItem)
        case .getSellProduct(let productFetchOption):
            let genreIDs = productFetchOption.genres.map { $0.id }
            
            return .requestParameters(parameters: ["sortOption" : productFetchOption.sortOption,
                                                   "genreId" : genreIDs,
                                                   "isOnSale" : productFetchOption.isOnSale,
                                                   "isUnopened" : productFetchOption.isUnopened],
                                      encoding: URLEncoding.queryString)
        case .getBuyProduct(let productFetchOption):
            let genreIDs = productFetchOption.genres.map { $0.id }

            return .requestParameters(parameters: ["sortOption" : productFetchOption.sortOption,
                                                   "genreId" : genreIDs,
                                                   "isOnSale" : productFetchOption.isOnSale],
                                      encoding: URLEncoding.queryString)
        }
    }
}
