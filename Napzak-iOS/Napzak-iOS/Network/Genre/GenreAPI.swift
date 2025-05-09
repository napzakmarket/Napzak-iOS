//
//  GenreAPI.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/28/25.
//

import Moya

enum GenreAPI {
    case getAllPreferGenre
    case getSearchPreferGenre(searchWord: String)
    case getAllGenreName
    case getSearchGenreName(searchWord: String)
    case registerPreferGenre(request: PreferGenreRequestDTO)
}

extension GenreAPI: BaseTargetType {

    var headerType: HeaderType {
        switch self {
        case .getAllPreferGenre, .getSearchPreferGenre, .getAllGenreName, .getSearchGenreName, .registerPreferGenre:
            return .accessTokenHeader
        }
    }
    
    var path: String {
        switch self {
        case .getAllPreferGenre:
            return "onboarding/genres"
        case .getSearchPreferGenre:
            return "onboarding/genres/search"
        case .getAllGenreName:
            return "genres"
        case .getSearchGenreName:
            return "genres/search"
        case .registerPreferGenre:
            return "stores/genres/register"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAllPreferGenre, .getSearchPreferGenre, .getAllGenreName, .getSearchGenreName:
            return .get
        case .registerPreferGenre:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getAllPreferGenre, .getAllGenreName:
            return .requestPlain
        case .getSearchPreferGenre(let searchWord):
            return .requestParameters(parameters: ["searchWord" : searchWord], encoding: URLEncoding.queryString)
        case .getSearchGenreName(let searchWord):
            return .requestParameters(parameters: ["searchWord" : searchWord], encoding: URLEncoding.queryString)
        case .registerPreferGenre(let request):
            return .requestJSONEncodable(request)
        }
    }
}
