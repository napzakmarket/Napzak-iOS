//
//  GenreNameResponseDTO.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/28/25.
//

import Foundation

typealias GenreNameResponseDTO = BaseResponseDTO<GenreNameData>

struct GenreNameData: Decodable {
    let genreList: [GenreDTO]
    let nextCursor: String?
    let externalLink: String?
}
