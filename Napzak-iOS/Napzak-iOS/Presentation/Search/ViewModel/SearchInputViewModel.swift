//
//  SearchInputViewModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/23/25.
//

import SwiftUI

import Combine
import os

@MainActor
final class SearchInputViewModel: ObservableObject {
    
    //MARK: - Property Wrappers

    @Published var searchInputText = ""
    @Published var isSearchCompleted: Bool = false
    @Published var searchRecommendations = [SearchWordModel]()
    @Published var genreRecommendations = [PreferGenreModel]()
    @Published var genreSearchResults = [
        GenreNameModel(id: 1, name: "산리오"),
        GenreNameModel(id: 2, name: "사카모토 데이즈"),
        GenreNameModel(id: 3, name: "산리오"),
        GenreNameModel(id: 4, name: "사카모토 데이즈"),
        GenreNameModel(id: 5, name: "산리오"),
        GenreNameModel(id: 6, name: "사카모토 데이즈")
    ]
    @Published var isRecommecdationDataDidLoad: Bool = false
    
    //MARK: - Properties
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "SearchInput")
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Init
    
    init() {
        $searchInputText
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] newSearchText in
                Task {
                    await self?.fetchGenreSearchResults()
                }
            }
            .store(in: &cancellables)
        
        Task {
            await fetchRecommendations()
        }
    }
}

extension SearchInputViewModel {
    
    //MARK: - Private Func
    
    private func fetchRecommendations() async {
        let result = await NetworkService.shared.productService.getSearchRecommendation()
        
        switch result {
        case .success(let response):
            guard let data = response.data else {
                logger.error("getSearchRecommendation: No data received")
                return
            }
            
            self.searchRecommendations = data.searchWordList.map { SearchWordModel(dto: $0) }
            self.genreRecommendations = data.genreList.map { PreferGenreModel(dto: $0) }
            isRecommecdationDataDidLoad = true
            
        case .failure(let error):
            logger.error("getSearchRecommendation failed: \(error.localizedDescription)")
        }
    }
    
    func fetchGenreSearchResults() async {
        let result = await NetworkService.shared.genreService.getSearchGenreName(searchWord: searchInputText)

        switch result {
        case .success(let response):
            guard let data = response.data else {
                logger.error("getSearchGenreName: No data received")
                return
            }
            
            self.genreSearchResults = data.genreList.map { GenreNameModel(dto: $0) }
            
        case .failure(let error):
            logger.error("getSearchGenreName failed: \(error.localizedDescription)")
        }
    }
}
