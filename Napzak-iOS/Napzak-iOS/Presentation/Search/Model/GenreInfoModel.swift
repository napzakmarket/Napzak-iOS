//
//  GenreInfoModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/29/25.
//

struct GenreInfoModel {
    let genreId: Int
    let genreName: String
    let tag: String?
    let coverImageUrl: String
    
    //MARK: - Init
    
    ///default init
    init(genreId: Int, genreName: String, tag: String, coverImageUrl: String) {
        self.genreId = genreId
        self.genreName = genreName
        self.tag = tag
        self.coverImageUrl = coverImageUrl
    }
    
    ///init for decoding
    init(dto: GenreInfoDTO) {
        self.genreId = dto.genreId
        self.genreName = dto.genreName
        self.tag = dto.tag
        self.coverImageUrl = dto.cover
    }
}
