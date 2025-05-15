//
//  ProductAPI.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/28/25.
//

import Moya

enum ProductAPI {
    case getSellProductsForMarket(storeOwnerId: Int, productFetchOption: ProductFetchOption)
    case getBuyProductsForMarket(storeOwnerId: Int, productFetchOption: ProductFetchOption)
    case sellRegister(registerItem: SellRegisterRequestDTO)
    case buyRegister(registerItem: BuyRegisterRequestDTO)
    case getSellProduct(productFetchOption: ProductFetchOption)
    case getBuyProduct(productFetchOption: ProductFetchOption)
    case getSellProductForSearch(searchWord: String, productFetchOption: ProductFetchOption)
    case getBuyProductForSearch(searchWord: String, productFetchOption: ProductFetchOption)
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
        case .getSellProductsForMarket(let storeOwnerId, _):
            return "products/sell/stores/\(storeOwnerId)"
        case .getBuyProductsForMarket(let storeOwnerId, _):
            return "products/buy/stores/\(storeOwnerId)"
        case .sellRegister, .getSellProduct:
            return "products/sell"
        case .buyRegister, .getBuyProduct:
            return "products/buy"
        case .getSellProductForSearch:
            return "products/sell/search"
        case .getBuyProductForSearch:
            return "products/buy/search"
        case .getProductDetailInfo(productId: let productId), .patchTradeStatus(let productId, _), .deleteProduct(let productId):
            return "products/\(productId)"
        case .getSellProductInfoForEdit(let productId):
            return "products/sell/modify/\(productId)"
        case .getBuyProductInfoForEdit(let productId):
            return "products/buy/modify/\(productId)"
        case .putSellProduct(let productId, _):
            return "products/sell/modify/\(productId)"
        case .putBuyProduct(let productId, _):
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
        case .getSellProductsForMarket(_, let productFetchOption):
            let genreIDs = productFetchOption.genres.map { $0.id }
            
            return .requestParameters(parameters: ["sortOption" : productFetchOption.sortOptionValue,
                                                   "genreId" : genreIDs,
                                                   "isOnSale" : productFetchOption.isOnSale,
                                                   "isUnopened" : productFetchOption.isUnopened],
                                      encoding: URLEncoding.queryString)
        case .getBuyProductsForMarket(_, let productFetchOption):
            let genreIDs = productFetchOption.genres.map { $0.id }

            return .requestParameters(parameters: ["sortOption" : productFetchOption.sortOptionValue,
                                                   "genreId" : genreIDs,
                                                   "isOnSale" : productFetchOption.isOnSale],
                                      encoding: URLEncoding.queryString)
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
        case .getSellProductForSearch(let searchWord, let productFetchOption):
            let genreIDs = productFetchOption.genres.map { $0.id }

            return .requestParameters(parameters: ["searchWord" : searchWord,
                                                   "sortOption" : productFetchOption.sortOptionValue,
                                                   "genreId" : genreIDs,
                                                   "isOnSale" : productFetchOption.isOnSale,
                                                   "isUnopened" : productFetchOption.isUnopened],
                                      encoding: URLEncoding.queryString)
        case .getBuyProductForSearch(let searchWord, let productFetchOption):
            let genreIDs = productFetchOption.genres.map { $0.id }

            return .requestParameters(parameters: ["searchWord" : searchWord,
                                                   "sortOption" : productFetchOption.sortOptionValue,
                                                   "genreId" : genreIDs,
                                                   "isOnSale" : productFetchOption.isOnSale,
                                                   "isUnopened" : productFetchOption.isUnopened],
                                      encoding: URLEncoding.queryString)        case .patchTradeStatus(_, let requestBody):
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
