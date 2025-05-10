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
    case getGenreDetailInfo(genreId: Int)
}

extension GenreAPI: BaseTargetType {

    var headerType: HeaderType {
        switch self {
        default:
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
        case .getGenreDetailInfo(let genreId):
            return "genres/detail/\(genreId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .registerPreferGenre:
            return .post
        default:
            return .get
        case .registerPreferGenre:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getAllPreferGenre, .getAllGenreName, .getGenreDetailInfo:
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
