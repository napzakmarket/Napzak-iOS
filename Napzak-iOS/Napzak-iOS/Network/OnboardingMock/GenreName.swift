//
//  GenreName.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/6/25.
//

import Foundation

struct GenreNameData: Codable {
    let genreList: [GenreName]
    let nextCursor: String?
    
    static var sample: GenreNameData {
        GenreNameData(
            genreList: [
                GenreName(id: 1, name: "나루토"),
                GenreName(id: 2, name: "원피스"),
                GenreName(id: 3, name: "드래곤볼"),
                GenreName(id: 4, name: "명탐정 코난"),
                GenreName(id: 5, name: "진격의 거인"),
                GenreName(id: 6, name: "슬램덩크")
            ],
            nextCursor: nil
        )
    }
}

struct GenreName: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "genreId"
        case name = "genreName"
    }
    
    static var sample: GenreName {
        GenreName(id: 1, name: "나루토")
    }
}
