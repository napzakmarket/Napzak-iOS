//
//  GenreNameModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/28/25.
//

struct GenreNameModel: Identifiable, Hashable {
    let id: Int
    let name: String
    
    static var sample: GenreNameModel {
        GenreNameModel(id: 1, name: "나루토")
    }
    
    static let sampleGenreList = [
        GenreNameModel(id: 1, name: "나루토"),
        GenreNameModel(id: 2, name: "원피스"),
        GenreNameModel(id: 3, name: "드래곤볼"),
        GenreNameModel(id: 4, name: "명탐정 코난"),
        GenreNameModel(id: 5, name: "진격의 거인"),
        GenreNameModel(id: 6, name: "슬램덩크")
    ]
}
