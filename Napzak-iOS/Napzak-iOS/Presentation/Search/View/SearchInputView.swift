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
            
            ScrollView(showsIndicators: false) {
                if viewModel.searchInputText.isEmpty {
                    defaultContentView
                } else {
                    typingContentView
                }
            }
            searchNavigationHeader
        }
        .ignoresSafeArea(edges: [.top])
        .toolbar(.hidden, for: .navigationBar)
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
                isFocused: _isSearchBarFocused
            )
            .frame(height: 38)
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
            genreRacommandationView
        }
        .padding(.horizontal, 20)
    }
    
    private var typingContentView: some View {
        LazyVStack(spacing: 0) {
            ForEach(viewModel.genreSearchResults) { genre in
                Button {
                    //TODO: - 장르 페이지로 이동
                } label: {
                    GenreItemView(genreName: genre.name)
                }
                Color.napzakGrayScale(.gray10)
                    .frame(height: 8)
            }
            Button {
                //TODO: - 화면 전환
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
        }
        .padding(.top, 131)
    }
    
    private var searchRecommendationView: some View {
        VStack(alignment: .leading, spacing: 22) {
            Text("추천 검색어")
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .frame(height: 18)
            
            SearchChipContainerView(
                titles: viewModel.searchRecommandations,
                action: { title in
                    //TODO: - 데이터 넘기며 화면 전환
                    print(title)
                }
            )
        }
        .padding(.top, 150)
    }
    
    private var genreRacommandationView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("추천 장르")
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .frame(height: 18)
            
            LazyVGrid(columns: columns, spacing: 13) {
                ForEach(viewModel.genreRecommandations) { genre in
                    Button {
                        //TODO: - 데이터 넘기며 화면 전환
                        print("\(genre.name)")
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
