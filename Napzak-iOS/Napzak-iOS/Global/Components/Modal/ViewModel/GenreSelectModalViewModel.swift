//
//  GenreSelectModalViewModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/21/25.
//

import SwiftUI

final class GenreSelectModalViewModel: ObservableObject {
    
    //MARK: - Property Wrappers

    @Published var selectedGenres: [GenreName] = []
    @Published var showToast : Bool = false
    
    //MARK: - Properties
    
    let allDummyGenres = [
        GenreName(id: 1, name: "산리오"),
        GenreName(id: 2, name: "은혼"),
        GenreName(id: 3, name: "주술회전"),
        GenreName(id: 4, name: "디즈니/픽사"),
        GenreName(id: 5, name: "원피스"),
        GenreName(id: 6, name: "레고/블럭"),
        GenreName(id: 7, name: "건담"),
        GenreName(id: 8, name: "귀멸의 칼날"),
        GenreName(id: 9, name: "나루토"),
        GenreName(id: 10, name: "나의 히어로 아카데미아"),
        GenreName(id: 11, name: "도쿄 리벤저스"),
        GenreName(id: 12, name: "드래곤볼"),
        GenreName(id: 13, name: "리락쿠마"),
        GenreName(id: 14, name: "마블"),
        GenreName(id: 15, name: "명탐정 코난"),
        GenreName(id: 16, name: "버추얼"),
        GenreName(id: 17, name: "보컬로이드")
    ]

    
    //MARK: - Init
    
    init(selectedGenres: [GenreName] = []) {
        self.selectedGenres = selectedGenres
    }
}

extension GenreSelectModalViewModel {
    
    //MARK: - Func
    
    func selectGenre(_ genre: GenreName) {
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
