//
//  GenreSelectModalViewModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/21/25.
//

import SwiftUI
import os

@MainActor
final class GenreSelectModalViewModel: ObservableObject {
    
    //MARK: - Property Wrappers

    @Published var genres: [GenreNameModel] = []
    @Published var selectedGenres: [GenreNameModel] = []
    @Published var inputGenreText = ""
    @Published var isSearchCompleted: Bool = false
    @Published var showToast : Bool = false
    
    //MARK: - Init
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "GenreSelection")

    init(selectedGenres: [GenreNameModel] = []) {
        self.selectedGenres = selectedGenres
        
        Task {
            await fetchAllGenres()
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
    
    //MARK: - Network Func
    
    func fetchAllGenres() async {
        let result = await NetworkService.shared.genreService.getAllGenreName()
        
        switch result {
        case .success(let response):
            guard let data = response.data else {
                logger.error("getAllGenreName: No data received")
                return
            }
            self.genres = data.genreList.map { GenreNameModel(dto: $0) }
            
        case .failure(let error):
            logger.error("getAllGenreName failed: \(error.localizedDescription)")
        }
    }
    
    
    func fetchSearchGenres(searchWord: String) async {
        let result = await NetworkService.shared.genreService.getSearchGenreName(searchWord: searchWord)
        
        switch result {
        case .success(let response):
            guard let data = response.data else {
                logger.error("getSearchGenreName: No data received")
                return
            }
            self.genres = data.genreList.map { GenreNameModel(dto: $0) }
            
        case .failure(let error):
            logger.error("getSearchGenreName failed: \(error.localizedDescription)")
        }
    }
}
