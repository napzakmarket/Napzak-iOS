//
//  GenreSelectionViewModel.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/7/25.
//

import Foundation

class GenreSelectionViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var genres: [PreferGenre] = []
    @Published var selectedGenres: [PreferGenre] = []
    @Published var showToast: Bool = false
    @Published var isButtonEnabled: Bool = false
    
    let maxGenreSelectionCount: Int = 7
    
    init() {
        loadDefaultGenres()
    }
    
    func toggleGenreSelection(_ genre: PreferGenre) {
        if let index = selectedGenres.firstIndex(where: { $0.id == genre.id }) {
            selectedGenres.remove(at: index)
        } else {
            if selectedGenres.count >= maxGenreSelectionCount {
                showToast = true
                
                Task {
                    try? await Task.sleep(for: .seconds(2))
                    await MainActor.run {
                        self.showToast = false
                    }
                }
                return
            }
            
            selectedGenres.append(genre)
        }
        
        updateButtonState()
    }
    
}

extension GenreSelectionViewModel {
    private func loadDefaultGenres() {
        // TODO: - 39개 데이터 가져오기
        genres = PreferGenreData.sample.genreList
    }
    
    private func updateButtonState() {
        isButtonEnabled = !selectedGenres.isEmpty
    }
}
