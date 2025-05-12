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
    case getSellProduct(productFetchOption: ProductFetchOption)
    case getBuyProduct(productFetchOption: ProductFetchOption)
    case getProductDetailInfo(productId: Int)
    case getSearchRecommendation
    case getSellProductInfoForEdit(productId: Int)
    case getBuyProductInfoForEdit(productId: Int)
    case putSellProduct(productId: Int, requestBody: SellRegisterRequestDTO)
    case putBuyProduct(productId: Int, requestBody: BuyRegisterRequestDTO)
    case patchTradeStatus(productId: Int, body: ChangeTradeStatusRequestDTO)
    case deleteProduct(productId: Int)
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
        case .getSellProducts(let storeOwnerId, _, _, _, _, _):
            return "products/sell/stores/\(storeOwnerId)"
        case .getBuyProducts(let storeOwnerId, _, _, _, _):
            return "products/buy/stores/\(storeOwnerId)"
        case .sellRegister, .getSellProduct:
            return "products/sell"
        case .buyRegister, .getBuyProduct:
            return "products/buy"
        case .getProductDetailInfo(productId: let productId), .patchTradeStatus(let productId, _), .deleteProduct(let productId):
            return "products/\(productId)"
        case .getSellProductInfoForEdit(let productId), .getBuyProductInfoForEdit(let productId):
            return "products/sell/modify/\(productId)"
        case .putSellProduct(let productId, _), .putBuyProduct(let productId, _):
            return "products/buy/modify/\(productId)"
        case .getSearchRecommendation:
            return "products/search/recommend"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sellRegister, .buyRegister:
            return .post
        case .putSellProduct, .putBuyProduct:
            return .put
        case .patchTradeStatus:
            return .patch
        case .deleteProduct:
            return .delete
        default:
            return .get
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
        case .getSellProduct(let productFetchOption):
            let genreIDs = productFetchOption.genres.map { $0.id }
            
            return .requestParameters(parameters: ["sortOption" : productFetchOption.sortOptionValue,
                                                   "genreId" : genreIDs,
                                                   "isOnSale" : productFetchOption.isOnSale,
                                                   "isUnopened" : productFetchOption.isUnopened],
                                      encoding: URLEncoding.queryString)
        case .getBuyProduct(let productFetchOption):
            let genreIDs = productFetchOption.genres.map { $0.id }

            return .requestParameters(parameters: ["sortOption" : productFetchOption.sortOptionValue,
                                                   "genreId" : genreIDs,
                                                   "isOnSale" : productFetchOption.isOnSale],
                                      encoding: URLEncoding.queryString)
        case .patchTradeStatus(_, let requestBody):
            return .requestJSONEncodable(requestBody)
        case .putSellProduct(_, let body):
            return .requestJSONEncodable(body)
        case .putBuyProduct(_, let body):
            return .requestJSONEncodable(body)
        default:
            return .requestPlain
        }
    }
}
