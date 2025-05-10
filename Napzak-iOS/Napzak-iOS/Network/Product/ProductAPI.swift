//
//  ProductAPI.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/28/25.
//

import Moya

enum ProductAPI {
    case getSellProducts(
        storeOwnerId: Int,
        sort: String?,
        isOnSale: Bool?,
        isUnopened: Bool?,
        genreId: Int?,
        cursor: String?
    )
    
    case getBuyProducts(
        storeOwnerId: Int,
        sort: String?,
        isOnSale: Bool?,
        genreId: Int?,
        cursor: String?
    )
    
    case sellRegister(registerItem: SellRegisterRequestDTO)
    case buyRegister(registerItem: BuyRegisterRequestDTO)
}

extension ProductAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .getSellProducts, .getBuyProducts:
            return .accessTokenHeader
        case .sellRegister:
            return .accessTokenHeader
        case .buyRegister:
            return .accessTokenHeader
        }
    }
    
    var path: String {
        switch self {
        case .getSellProducts(let storeOwnerId, _, _, _, _, _):
            return "/api/v1/products/sell/stores/\(storeOwnerId)"
        case .getBuyProducts(let storeOwnerId, _, _, _, _):
            return "/api/v1/products/buy/stores/\(storeOwnerId)"
        case .sellRegister:
            return "products/sell"
        case .buyRegister:
            return "products/buy"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getSellProducts, .getBuyProducts:
            return .get
        case .sellRegister:
            return .post
        case .buyRegister:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getSellProducts(_, let sort, let isOnSale, let isUnopened, let genreId, let cursor):
            var params: [String: Any] = [:]
            
            if let sort = sort {
                params["sort"] = sort
            }
            
            if let isOnSale = isOnSale {
                params["isOnSale"] = isOnSale
            }
            
            if let isUnopened = isUnopened {
                params["isUnopened"] = isUnopened
            }
            
            if let genreId = genreId {
                params["genreId"] = genreId
            }
            
            if let cursor = cursor {
                params["cursor"] = cursor
            }
            
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            
        case .getBuyProducts(_, let sort, let isOnSale, let genreId, let cursor):
            var params: [String: Any] = [:]
            
            if let sort = sort {
                params["sort"] = sort
            }
            
            if let isOnSale = isOnSale {
                params["isOnSale"] = isOnSale
            }
            
            if let genreId = genreId {
                params["genreId"] = genreId
            }
            
            if let cursor = cursor {
                params["cursor"] = cursor
            }
            
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            
        case .sellRegister(let registerItem):
            return .requestJSONEncodable(registerItem)
        case .buyRegister(let registerItem):
            return .requestJSONEncodable(registerItem)
        }
    }
}
