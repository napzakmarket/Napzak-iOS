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
                onSubmit: {
                    navigationRouter.push(next: .searchView(searchWord: viewModel.searchInputText))
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
                navigationRouter.push(next: .searchView(searchWord: viewModel.searchInputText))
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
                    navigationRouter.push(next: .searchView(searchWord: title))
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
