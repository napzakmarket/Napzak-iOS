//
//  GenreDetailResponseDTO.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 5/11/25.
//

import Foundation

typealias GenreDetailResponseDTO = BaseResponseDTO<GenreInfoDTO>

struct GenreInfoDTO: Decodable {
    let genreId: Int
    let genreName: String
    let tag: String
    let cover: String
}
