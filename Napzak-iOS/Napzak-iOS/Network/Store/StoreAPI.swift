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
    case validateNickname(request: NicknameRequestDTO)
    case registerNickname(request: NicknameRequestDTO)
}

extension StoreAPI: BaseTargetType {
    
    var headerType: HeaderType {
        switch self {
        case .getMyPageInfo, .getStoreDetail, .modifyProfile, .validateNickname, .registerNickname, .getTerms:
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
        case .validateNickname:
            return "stores/nickname/check"
        case .registerNickname:
            return "stores/nickname/register"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyPageInfo, .getStoreDetail, .getTerms:
            return .get
        case .modifyProfile:
            return .put
        case .validateNickname, .registerNickname:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMyPageInfo, .getStoreDetail, .getTerms:
            return .requestPlain
        case .modifyProfile(let request):
            return .requestJSONEncodable(request)
        case .validateNickname(let request), .registerNickname(let request):
            return .requestJSONEncodable(request)
        }
    }
}
