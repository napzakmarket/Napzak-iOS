//
//  SearchRecommendationResponseDTO.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 5/11/25.
//

typealias SearchRecommendationResponseDTO = BaseResponseDTO<SearchRecommendationDTO>

struct SearchRecommendationDTO: Decodable {
    let searchWordList: [SearchWordDTO]
    let genreList: [GenreDTO]
}

struct SearchWordDTO: Decodable {
    let searchWordId: Int
    let searchWord: String
}
