//
//  GenreSelectionViewModel.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/7/25.
//

import Foundation
import Combine
import os

@MainActor
final class GenreSelectionViewModel: ObservableObject {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "GenreSelection")
    
    @Published var genres: [PreferGenreModel] = []
    @Published var selectedGenres: [PreferGenreModel] = []
    @Published var searchText: String = ""
    @Published var showToast: Bool = false
    @Published var isLoading: Bool = false
    
    private let genreService = NetworkService.shared.genreService
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchText
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] newSearchText in
                Task {
                    await self?.searchGenres()
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchAllGenres() async {
        let result = await genreService.getAllPreferGenre()
        switch result {
        case .success(let response):
            guard let genreList = response.data?.genreList else { return }
            self.genres = genreList.map { PreferGenreModel(dto: $0) }
        case .failure(let error):
            logger.error("registerUsername failed: \(error.errorDescription ?? "Unknown error")")
        }
    }
    
    func searchGenres() async {
        guard !searchText.isEmpty else {
            await fetchAllGenres()
            return
        }
        
        let result = await genreService.getSearchPreferGenre(searchWord: searchText)
        switch result {
        case .success(let response):
            guard let genreList = response.data?.genreList else { return }
            self.genres = genreList.map { PreferGenreModel(dto: $0) }
        case .failure(let error):
            logger.error("registerUsername failed: \(error.errorDescription ?? "Unknown error")")
        }
    }
    
    func registerSelectedGenres() async -> Bool {
        guard !selectedGenres.isEmpty else { return false }
        
        isLoading = true
        let genreIds = selectedGenres.map { $0.id }
        let request = PreferGenreRequestDTO(genreIds: genreIds)
        
        let result = await genreService.registerPreferGenre(request: request)
        isLoading = false
        
        switch result {
        case .success(_):
            return true
        case .failure(let error):
            logger.error("registerPreferGenre failed: \(error.errorDescription ?? "Unknown error")")
            return false
        }
    }
    
    func toggleGenreSelection(_ genre: PreferGenreModel) {
        if selectedGenres.contains(genre) {
            selectedGenres.removeAll { $0.id == genre.id }
        } else if selectedGenres.count >= 7 {
            showToast = true
            Task {
                try? await Task.sleep(for: .seconds(2))
                await MainActor.run {
                    self.showToast = false
                }
            }
        } else {
            selectedGenres.append(genre)
        }
    }
}
