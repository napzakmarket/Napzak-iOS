//
//  StoreAPI.swift
//  Napzakmarket-iOS
//
//  Created by 어진 on 5/3/25.
//

import Moya

enum StoreAPI {
    case getMyPageInfo
    case getStoreDetail(storeId: Int)
    case modifyProfile(request: StoreModifyProfileRequestDTO)
    case getTerms
}

extension StoreAPI: BaseTargetType {
    
    var headerType: HeaderType {
        switch self {
        case .getMyPageInfo, .getStoreDetail, .modifyProfile, .getTerms:
            return .accessTokenHeader
        }
    }
    
    var path: String {
        switch self {
        case .getMyPageInfo:
            return "stores/mypage"
        case .getStoreDetail(let storeId):
            return "stores/\(storeId)"
        case .modifyProfile:
            return "stores/modify/profile"
        case .getTerms:
            return "stores/terms"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyPageInfo, .getStoreDetail, .getTerms:
            return .get
        case .modifyProfile:
            return .put
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMyPageInfo, .getStoreDetail, .getTerms:
            return .requestPlain
        case .modifyProfile(let request):
            return .requestJSONEncodable(request)
        }
    }
}
