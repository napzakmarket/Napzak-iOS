//
//  GenreSelectModalViewModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/21/25.
//

import SwiftUI

@MainActor
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
        NetworkService.shared.genreService.getAllGenreName { result in
            switch result {
            case .success(let response):
                guard let response else { return }
                guard let receivedData = response.data else { return }
                
                self.allGenres = receivedData.genreList.map { GenreNameModel(dto: $0) }
            default:
                break
            }
        }
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
