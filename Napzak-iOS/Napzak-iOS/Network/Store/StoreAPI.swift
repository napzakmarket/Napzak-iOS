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
    case registerPhoneVerification
    case getTerms
    case validateNickname(request: NicknameRequestDTO)
    case registerNickname(request: NicknameRequestDTO)
    case postBlockStore(storeId: Int)
    case postUnblockStore(storeId: Int)
}

extension StoreAPI: BaseTargetType {
    
    var headerType: HeaderType {
        switch self {
        default:
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
        case .registerPhoneVerification:
            return "stores/phone-verifications"
        case .getTerms:
            return "stores/terms"
        case .validateNickname:
            return "stores/nickname/check"
        case .registerNickname:
            return "stores/nickname/register"
        case .postBlockStore(let storeId):
            return "stores/block/\(storeId)"
        case .postUnblockStore(let storeId):
            return "stores/unblock/\(storeId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyPageInfo, .getStoreDetail, .getTerms:
            return .get
        case .modifyProfile:
            return .put
        case .registerPhoneVerification:
            return .patch
        default:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .modifyProfile(let request):
            return .requestJSONEncodable(request)
        case .validateNickname(let request), .registerNickname(let request):
            return .requestJSONEncodable(request)
        default:
            return .requestPlain
        }
    }
}
