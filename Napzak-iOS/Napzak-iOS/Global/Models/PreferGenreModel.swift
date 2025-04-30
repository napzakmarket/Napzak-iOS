//
//  PreferGenreModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/28/25.
//

struct PreferGenreModel: Identifiable, Hashable {
    let id: Int
    let name: String
    let image: String?
    
    static let sample = PreferGenreModel(id: 1, name: "스폰지밥", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOrPQwOTaU_L8EIFpWzLjgiUHc3CcmGEq84A&s")
    
    static let sampleGenreList = [
        PreferGenreModel(id: 1, name: "나루토", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOrPQwOTaU_L8EIFpWzLjgiUHc3CcmGEq84A&s"),
        PreferGenreModel(id: 2, name: "원피스", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOrPQwOTaU_L8EIFpWzLjgiUHc3CcmGEq84A&s"),
        PreferGenreModel(id: 3, name: "드래곤볼", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOrPQwOTaU_L8EIFpWzLjgiUHc3CcmGEq84A&s"),
        PreferGenreModel(id: 4, name: "명탐정 코난", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOrPQwOTaU_L8EIFpWzLjgiUHc3CcmGEq84A&s"),
        PreferGenreModel(id: 5, name: "진격의 거인", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOrPQwOTaU_L8EIFpWzLjgiUHc3CcmGEq84A&s"),
        PreferGenreModel(id: 6, name: "슬램덩크", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOrPQwOTaU_L8EIFpWzLjgiUHc3CcmGEq84A&s"),
        PreferGenreModel(id: 7, name: "하이큐", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOrPQwOTaU_L8EIFpWzLjgiUHc3CcmGEq84A&s"),
        PreferGenreModel(id: 8, name: "귀멸의 칼날", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOrPQwOTaU_L8EIFpWzLjgiUHc3CcmGEq84A&s"),
        PreferGenreModel(id: 9, name: "토리코", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOrPQwOTaU_L8EIFpWzLjgiUHc3CcmGEq84A&s"),
        PreferGenreModel(id: 10, name: "블리치", image: "https://kream-phinf.pstatic.net/MjAyNDEyMTFfMjAw/MDAxNzMzODkzNTExNDUz.7bZDbRzaJ-jhBHficneUKET4CyE_kfaaOxLvoODV2gg.PNG/a_61618fd382884ad3b37ce139cf1a4147.png?type=m_webp")
    ]
}
