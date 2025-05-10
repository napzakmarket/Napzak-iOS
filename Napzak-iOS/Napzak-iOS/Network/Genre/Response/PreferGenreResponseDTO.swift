//
//  PreferGenreResponseDTO.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/28/25.
//

import Foundation

typealias PreferGenreResponseDTO = BaseResponseDTO<PreferGenreData>

struct PreferGenreData: Decodable {
    let genreList: [GenreDTO]
    var nextCursor: String?
    let externalLink: String?
}
