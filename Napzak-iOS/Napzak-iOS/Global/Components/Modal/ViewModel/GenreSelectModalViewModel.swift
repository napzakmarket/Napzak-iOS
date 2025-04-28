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

    @Published var genres: [GenreNameModel] = []
    @Published var selectedGenres: [GenreNameModel] = []
    @Published var inputGenreText = ""
    @Published var isSearchCompleted: Bool = false
    @Published var showToast : Bool = false
    
    //MARK: - Init
    
    init(selectedGenres: [GenreNameModel] = []) {
        self.selectedGenres = selectedGenres
        
        fetchAllGenres()
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
    
    //MARK: - Network Func
    
    func fetchAllGenres() {
        NetworkService.shared.genreService.getAllGenreName { result in
            switch result {
            case .success(let response):
                guard let response else { return }
                guard let receivedData = response.data else { return }
                
                self.genres = receivedData.genreList.map { GenreNameModel(dto: $0) }
            default:
                break
            }
        }
    }
    
    func fetchSearchGenres(searchWord: String) {
        NetworkService.shared.genreService.getSearchGenreName(searchWord: searchWord) { result in
            switch result {
            case .success(let response):
                guard let response else { return }
                guard let receivedData = response.data else { return }
                
                self.genres = receivedData.genreList.map { GenreNameModel(dto: $0) }
            default:
                break
            }
        }
    }
}
