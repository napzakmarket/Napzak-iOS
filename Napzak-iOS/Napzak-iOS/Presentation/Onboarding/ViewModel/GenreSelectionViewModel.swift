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
    private let storeService = NetworkService.shared.storeService
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchText
            .dropFirst()
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
    
    func registerUser(username: String) async -> Bool {
        guard !selectedGenres.isEmpty else { return false }
        
        isLoading = true
        
        let nicknameRequest = NicknameRequestDTO(nickname: username)
        let nicknameResult = await storeService.registerNickname(request: nicknameRequest)
        
        switch nicknameResult {
        case .success:
            let genreIds = selectedGenres.map { $0.id }
            let genreRequest = PreferGenreRequestDTO(genreIds: genreIds)
            let genreResult = await genreService.registerPreferGenre(request: genreRequest)

            switch genreResult {
            case .success(_):
                let phoneResult = await storeService.registerPhoneVerification()
                isLoading = false

                switch phoneResult {
                case .success:
                    logger.info("User, genres, and phone number registered successfully.")
                    return true
                case .failure(let error):
                    logger.error("registerPhoneVerification failed: \(error.localizedDescription)")
                    return false
                }
            case .failure(let error):
                isLoading = false
                logger.error("registerPreferGenre failed: \(error.localizedDescription)")
                return false
            }
        case .failure(let error):
            isLoading = false
            logger.error("registerNickname failed: \(error.localizedDescription)")
            return false
        }
    }
    
    func registerOnlyUsername(username: String) async -> Bool {
        isLoading = true
        let nicknameRequest = NicknameRequestDTO(nickname: username)
        let result = await storeService.registerNickname(request: nicknameRequest)
        
        switch result {
        case .success:
            let phoneResult = await storeService.registerPhoneVerification()
            isLoading = false

            switch phoneResult {
            case .success:
                logger.info("Username and phone number registered successfully, skipping genres.")
                return true
            case .failure(let error):
                logger.error("registerPhoneVerification failed for skip action: \(error.localizedDescription)")
                return false
            }
        case .failure(let error):
            isLoading = false
            logger.error("registerNickname failed for skip action: \(error.localizedDescription)")
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
