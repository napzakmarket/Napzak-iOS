//
//  SearchInputView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/22/25.
//

import SwiftUI

import Kingfisher

struct SearchInputView: View {
    
    //MARK: - Property Wrappers
    
    @EnvironmentObject private var navigationRouter: NavigationRouter
    
    @StateObject private var viewModel = SearchInputViewModel()
        
    @FocusState private var isSearchBarFocused: Bool
    
    //MARK: - Properties
    
    private let mixpanelManager = MixpanelManager.shared
    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    //MARK: - Body
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.napzakGrayScale(.gray10)
                .ignoresSafeArea(edges: [.bottom])
            
            if viewModel.isRecommecdationDataDidLoad {
                ScrollView(showsIndicators: false) {
                    if viewModel.searchInputText.isEmpty {
                        defaultContentView
                    } else {
                        typingContentView
                    }
                }
            }
            searchNavigationHeader
        }
        .onTapGesture {
            isSearchBarFocused = false
        }
        .ignoresSafeArea(edges: [.top])
        .toolbar(.hidden, for: .navigationBar)
        .onChange(of: viewModel.searchInputText) { newValue in
            Task {
                await viewModel.fetchGenreSearchResults()
            }
        }
        .onAppear {
            mixpanelManager.trackEvent(event: "Opened Search")
        }
    }
}

extension SearchInputView {
    
    //MARK: - UI Properties
    
    private var searchNavigationHeader: some View {
        HStack(alignment: .center, spacing: 0) {
            Button {
                navigationRouter.pop()
            } label: {
                Image(.iconBack)
                    .frame(width: 34)
            }
            
            SearchBar(
                placeholder: "원하는 장르를 직접 검색해보세요!",
                text: $viewModel.searchInputText,
                isCompleted: $viewModel.isSearchCompleted,
                isFocused: _isSearchBarFocused,
                onSearchButtonTapped: {
                    if viewModel.searchInputText.isEmpty { return }
                    else {
                        SearchEventManager.shared.searchCompleted.send(viewModel.searchInputText)
                        mixpanelManager.trackEvent(event: "Executed Search", properties: ["search_source": "icon",
                                                                                         "keyword": viewModel.searchInputText])
                    }
                },
                onSubmit: {
                    SearchEventManager.shared.searchCompleted.send(viewModel.searchInputText)
                    mixpanelManager.trackEvent(event: "Executed Search", properties: ["search_source": "enter",
                                                                                     "keyword": viewModel.searchInputText])
                }
            )
            .frame(height: 38)
            .onAppear {
                isSearchBarFocused = true
            }
        }
        .padding(.leading, 16)
        .padding(.trailing, 28)
        .padding(.top, 66)
        .padding(.bottom, 20)
        .background(
            Color.napzakGrayScale(.white)
                .shadow(color: .black.opacity(0.1), radius: 2)
        )
    }
    
    private var defaultContentView: some View {
        VStack(spacing: 46) {
            searchRecommendationView
            genreRecommendationView
        }
        .padding(.horizontal, 20)
    }
    
    private var typingContentView: some View {
        LazyVStack(spacing: 0) {
            Button {
                SearchEventManager.shared.searchCompleted.send(viewModel.searchInputText)
                mixpanelManager.trackEvent(event: "Executed Search", properties: ["search_source": "searchbar",
                                                                                 "keyword": viewModel.searchInputText])
            } label: {
                HStack(alignment: .center, spacing: 6) {
                    Image(.imgSearchInput)
                        .padding(.leading, 28)
                    
                    Text(viewModel.searchInputText)
                        .applyNapzakFont(.body5SemiBold14)
                        .foregroundColor(Color.napzakGrayScale(.gray500))
                    
                    Spacer()
                }
                .frame(height: 60)
                .background(Color.napzakGrayScale(.white))
            }
            ForEach(viewModel.genreSearchResults) { genre in
                Color.napzakGrayScale(.gray10)
                    .frame(height: 8)
                Button {
                    navigationRouter.push(next: .genreDetailView(genreId: genre.id,
                                                                 genreName: genre.name))
                    mixpanelManager.trackEvent(event: "Executed Search", properties: ["search_source": "genre_page",
                                                                                     "keyword": viewModel.searchInputText,
                                                                                      "genre_name": genre.name])
                } label: {
                    GenreItemView(genreName: genre.name)
                }
            }
        }
        .padding(.top, 131)
    }
    
    private var searchRecommendationView: some View {
        VStack(alignment: .leading, spacing: 22) {
            Text("추천 검색어")
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .frame(height: 18)
            
            PlainChipContainerView(
                titles: viewModel.searchRecommendations.map { $0.searchWord },
                action: { title in
                    let index = viewModel.searchRecommendations.firstIndex(where: { $0.searchWord == title }) ?? 0
                    
                    mixpanelManager.trackEvent(event: "Clicked Suggestion", properties: ["suggestion_type": "keyword",
                                                                                         "suggestion_index": index])
                    SearchEventManager.shared.searchCompleted.send(title)
                }
            )
        }
        .padding(.top, 150)
    }
    
    private var genreRecommendationView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("추천 장르")
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .frame(height: 18)
            
            LazyVGrid(columns: columns, spacing: 13) {
                ForEach(viewModel.genreRecommendations) { genre in
                    Button {
                        let index = viewModel.genreRecommendations.firstIndex(where: { $0.name == genre.name }) ?? 0

                        mixpanelManager.trackEvent(event: "Clicked Suggestion", properties: ["suggestion_type": "genre",
                                                                                             "suggestion_index": index])
                        navigationRouter.push(next: .genreDetailView(genreId: genre.id,
                                                                     genreName: genre.name))
                    } label: {
                        VStack(spacing: 7)  {
                            Group {
                                if let imageURL = genre.image,
                                   let url = URL(string: imageURL) {
                                    KFImage(url)
                                        .placeholder {
                                            Circle()
                                                .fill(Color.napzakGrayScale(.gray100))
                                        }.retry(maxCount: 3, interval: .seconds(3))
                                        .onFailure { error  in
                                            print("failure: \(error.localizedDescription)")
                                        }
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                    
                                } else {
                                    Circle()
                                        .fill(Color.napzakGrayScale(.gray100))
                                }
                            }
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            
                            Text(genre.name)
                                .applyNapzakFont(.caption3Regular12)
                                .foregroundStyle(Color.napzakGrayScale(.gray300))
                        }
                    }
                }
            }
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    SearchInputView()
}
