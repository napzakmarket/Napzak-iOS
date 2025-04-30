//
//  SearchInputViewModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/23/25.
//

import SwiftUI

final class SearchInputViewModel: ObservableObject {
    
    //MARK: - Property Wrappers

    @Published var searchInputText = ""
    @Published var isSearchCompleted: Bool = false
    @Published var searchRecommendations = [String]()
    @Published var genreRecommendations = [PreferGenreModel]()
    @Published var genreSearchResults = [
        GenreNameModel(id: 1, name: "산리오"),
        GenreNameModel(id: 2, name: "사카모토 데이즈"),
        GenreNameModel(id: 3, name: "산리오"),
        GenreNameModel(id: 4, name: "사카모토 데이즈"),
        GenreNameModel(id: 5, name: "산리오"),
        GenreNameModel(id: 6, name: "사카모토 데이즈")
    ]
    
    //MARK: - Init
    
    init() {
        fetchSearchRecommendations()
        fetchGenreRecommendations()
    }
}

extension SearchInputViewModel {
    
    //MARK: - Private Func
    
    private func fetchSearchRecommendations() {
        searchRecommendations = ["헌터x헌터 룩업", "주술회전 고죠 사토루", "웨딩 마이멜로디", "짱구는 못말려 날아라 수제김밥", "은혼 긴토키", "하이큐 모찌모찌 마스코트", "하이큐 모찌모찌 마스코투"]
    }
    
    private func fetchGenreRecommendations() {
        genreRecommendations = [
            PreferGenreModel(id: 1, name: "나루토", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOrPQwOTaU_L8EIFpWzLjgiUHc3CcmGEq84A&s"),
            PreferGenreModel(id: 2, name: "원피스", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOrPQwOTaU_L8EIFpWzLjgiUHc3CcmGEq84A&s"),
            PreferGenreModel(id: 3, name: "드래곤볼", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOrPQwOTaU_L8EIFpWzLjgiUHc3CcmGEq84A&s"),
            PreferGenreModel(id: 4, name: "명탐정 코난", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOrPQwOTaU_L8EIFpWzLjgiUHc3CcmGEq84A&s"),
            PreferGenreModel(id: 5, name: "진격의 거인", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOrPQwOTaU_L8EIFpWzLjgiUHc3CcmGEq84A&s"),
            PreferGenreModel(id: 6, name: "슬램덩크", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOrPQwOTaU_L8EIFpWzLjgiUHc3CcmGEq84A&s"),
            PreferGenreModel(id: 7, name: "하이큐", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOrPQwOTaU_L8EIFpWzLjgiUHc3CcmGEq84A&s"),
            PreferGenreModel(id: 8, name: "귀멸의 칼날", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOrPQwOTaU_L8EIFpWzLjgiUHc3CcmGEq84A&s"),
            PreferGenreModel(id: 9, name: "토리코", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOrPQwOTaU_L8EIFpWzLjgiUHc3CcmGEq84A&s")
        ]
    }
}
