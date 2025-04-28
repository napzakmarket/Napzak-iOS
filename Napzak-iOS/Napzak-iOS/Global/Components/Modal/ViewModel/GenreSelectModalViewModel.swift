//
//  GenreSelectModalViewModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/21/25.
//

import SwiftUI

final class GenreSelectModalViewModel: ObservableObject {
    
    //MARK: - Property Wrappers

    @Published var allGenres: [GenreNameModel] = []
    @Published var selectedGenres: [GenreNameModel] = []
    @Published var showToast : Bool = false

    
    //MARK: - Init
    
    init(selectedGenres: [GenreNameModel] = []) {
        self.selectedGenres = selectedGenres
        
        fetchAllGenres()
    }
}

private extension GenreSelectModalViewModel {
    
    //MARK: - Private Func
    
    func fetchAllGenres() {
        allGenres = [
            GenreNameModel(id: 1, name: "산리오"),
            GenreNameModel(id: 2, name: "은혼"),
            GenreNameModel(id: 3, name: "주술회전"),
            GenreNameModel(id: 4, name: "디즈니/픽사"),
            GenreNameModel(id: 5, name: "원피스"),
            GenreNameModel(id: 6, name: "레고/블럭"),
            GenreNameModel(id: 7, name: "건담"),
            GenreNameModel(id: 8, name: "귀멸의 칼날"),
            GenreNameModel(id: 9, name: "나루토"),
            GenreNameModel(id: 10, name: "나의 히어로 아카데미아"),
            GenreNameModel(id: 11, name: "도쿄 리벤저스"),
            GenreNameModel(id: 12, name: "드래곤볼"),
            GenreNameModel(id: 13, name: "리락쿠마"),
            GenreNameModel(id: 14, name: "마블"),
            GenreNameModel(id: 15, name: "명탐정 코난"),
            GenreNameModel(id: 16, name: "버추얼"),
            GenreNameModel(id: 17, name: "보컬로이드")
        ]
    }
}

extension GenreSelectModalViewModel {
    
    //MARK: - Func
    
    func selectGenre(_ genre: GenreNameModel) {
        if selectedGenres.contains(genre) {
            selectedGenres.removeAll(where: { $0 == genre })
        } else if !selectedGenres.contains(genre) && selectedGenres.count < 7 {
            selectedGenres.append(genre)
        } else {
            showToast = true
            
            Task {
                try? await Task.sleep(for: .seconds(2))
                await MainActor.run {
                    self.showToast = false
                }
            }
        }
    }
}
