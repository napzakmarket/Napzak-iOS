//
//  GenreService.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/28/25.
//

import Moya

protocol GenreServiceProtocol {
    func getAllPreferGenre(completion: @escaping (NetworkResult<PreferGenreResponseDTO>) -> ())
    func getSearchPreferGenre(searchWord: String, completion: @escaping(NetworkResult<PreferGenreResponseDTO>) -> ())
    func getAllGenreName(completion: @escaping (NetworkResult<GenreNameResponseDTO>) -> ())
    func getSearchGenreName(searchWord: String, completion: @escaping (NetworkResult<GenreNameResponseDTO>) -> ())
}

final class GenreService: BaseService, GenreServiceProtocol {
    
    private let provider = MoyaProvider<GenreAPI>.init(plugins: [MoyaPlugin()])
    
    func getAllPreferGenre(completion: @escaping (NetworkResult<PreferGenreResponseDTO>) -> ()) {
        request(provider, .getAllPreferGenre, completion: completion)
    }
    
    func getSearchPreferGenre(searchWord: String, completion: @escaping (NetworkResult<PreferGenreResponseDTO>) -> ()) {
        request(provider, .getSearchPreferGenre(searchWord: searchWord), completion: completion)
    }
    
    func getAllGenreName(completion: @escaping (NetworkResult<GenreNameResponseDTO>) -> ()) {
        request(provider, .getAllGenreName, completion: completion)
    }
    
    func getSearchGenreName(searchWord: String, completion: @escaping (NetworkResult<GenreNameResponseDTO>) -> ()) {
        request(provider, .getSearchGenreName(searchWord: searchWord), completion: completion)
    }
}
