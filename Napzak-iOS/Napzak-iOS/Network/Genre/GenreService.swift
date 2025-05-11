//
//  GenreService.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/28/25.
//
import Foundation
import Moya

protocol GenreServiceProtocol {
    func getAllPreferGenre() async -> Result<PreferGenreResponseDTO, NetworkError>
    func getSearchPreferGenre(searchWord: String) async -> Result<PreferGenreResponseDTO, NetworkError>
    func getAllGenreName() async -> Result<GenreNameResponseDTO, NetworkError>
    func getSearchGenreName(searchWord: String) async -> Result<GenreNameResponseDTO, NetworkError>
    func registerPreferGenre(request: PreferGenreRequestDTO) async -> Result<PreferGenreResponseDTO, NetworkError>
    func getGenreDetailInfo(genreId: Int) async -> Result<GenreDetailResponseDTO, NetworkError>
}

final class GenreService: BaseService, GenreServiceProtocol {
    
    private let provider = MoyaProvider<GenreAPI>.init(plugins: [MoyaPlugin()])
    
    func getAllPreferGenre() async -> Result<PreferGenreResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getAllPreferGenre)
    }
    
    func getSearchPreferGenre(searchWord: String) async -> Result<PreferGenreResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getSearchPreferGenre(searchWord: searchWord))
    }
    
    func getAllGenreName() async -> Result<GenreNameResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getAllGenreName)
    }
    
    func getSearchGenreName(searchWord: String) async -> Result<GenreNameResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getSearchGenreName(searchWord: searchWord))
    }
    
    func registerPreferGenre(request: PreferGenreRequestDTO) async -> Result<PreferGenreResponseDTO, NetworkError> {
        return await requestDecodable(provider, .registerPreferGenre(request: request))
    }
    
    func getGenreDetailInfo(genreId: Int) async -> Result<GenreDetailResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getGenreDetailInfo(genreId: genreId))
    }
}
