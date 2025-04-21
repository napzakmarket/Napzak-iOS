//
//  SearchView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/15/25.
//

import SwiftUI

struct SearchView: View {
    
    //MARK: - Property Wrappers

    @StateObject private var viewModel = SearchViewModel()
    
    @Binding var isGenreSelectModalPresented: Bool
        
    //MARK: - Properties
    
    private let productCellWidth = (UIScreen.main.bounds.width - 76) / 2
    private let columns = [GridItem(.flexible(), spacing: 20), GridItem(.flexible())]
    
    //MARK: - Body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                searchHeader
                    .padding(.top, 75)
                productScrollView
                Spacer()
            }
            
            if isGenreSelectModalPresented {
                Color.napzakTransparency(.transBlack)
                    .onTapGesture {
                        withAnimation {
                            isGenreSelectModalPresented = false
                        }
                    }
                    .transition(.opacity)
                    .zIndex(1)
                
                GenreSelectModalView(
                    isGenreSelectModalPresented: $isGenreSelectModalPresented,
                    adaptedGenres: $viewModel.productFetchOption.genres
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(2)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isGenreSelectModalPresented)
        .ignoresSafeArea()
    }
}

extension SearchView {
    
    //MARK: - UI Properties
    
    private var searchHeader: some View {
        VStack(spacing: 0){
            searchButton
                .padding(.horizontal, 27)
                .padding(.bottom, 19)
            
            ZStack(alignment: .top) {
                shadowBackground
                
                VStack(alignment: .leading, spacing: 0) {
                    NZSegmentedControl(selectedTabIndex: $viewModel.selectedTabIndex, tabs: ["팔아요", "구해요"],  spacing: 16)
                    
                    FilterContainerView(
                        isGenreSelectModalPresented: $isGenreSelectModalPresented,
                        selectedTabIndex: $viewModel.selectedTabIndex,
                        selectedGenres: $viewModel.productFetchOption.genres,
                        isUnopened: $viewModel.productFetchOption.isUnopened,
                        isOnSale: $viewModel.productFetchOption.isOnSale
                    )
                    .frame(height: 54)
                }
                .padding(.horizontal, 28)
            }
        }
    }
    
    private var searchButton: some View {
        Button {
            // TODO: - 검색 화면 전환
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.napzakGrayScale(.gray50))
                HStack(spacing: 0) {
                    Text("어떤 상품을 찾고 계신가요?")
                        .foregroundStyle(Color.napzakGrayScale(.gray200))
                        .applyNapzakFont(.caption2Medium12)
                    Spacer()
                    Image(.iconSearch)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .padding(.leading, 16)
                .padding(.trailing, 10)
            }
            .frame(height: 39)
        }
    }
    
    private var shadowBackground: some View {
        ZStack(alignment: .top) {
            Color.napzakGrayScale(.gray10)
            Color.napzakGrayScale(.white)
                .frame(height: 47)
                .shadow(color: .black.opacity(0.1), radius: 4)
        }
        .frame(height: 103)
        .clipped()
    }
    
    private var genreListView: some View {
        LazyVStack(spacing: 0) {
            ForEach(viewModel.productFetchOption.genres.indices, id: \.self) { i in
                Button {
                    //TODO: - 장르 페이지로 이동
                } label: {
                    GenreItemView(genreName: viewModel.productFetchOption.genres[i].name)
                        .frame(height: 64)
                }
                Color.napzakGrayScale(.gray10)
                    .frame(height: 4)
            }
        }
    }
    
    private var productScrollView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                if !viewModel.productFetchOption.genres.isEmpty {
                    genreListView
                }
                HStack(alignment: .center, spacing: 3) {
                    Text("상품")
                        .foregroundStyle(Color.napzakGrayScale(.gray500))
                        .applyNapzakFont(.body5SemiBold14)
                    Text("\(viewModel.dummyProducts.count)개")
                        .foregroundStyle(Color.napzakPrimary(.purple500))
                        .applyNapzakFont(.body5SemiBold14)
                    Spacer()
                    Button {
                    //TODO: - 상품 정렬
                    } label: {
                        HStack(alignment: .center, spacing: 4) {
                            Text("최신순")
                                .foregroundStyle(Color.napzakGrayScale(.gray200))
                                .applyNapzakFont(.caption1SemiBold12)
                            Image(.iconArrowDown)
                                .renderingMode(.template)
                                .foregroundColor(Color.napzakGrayScale(.gray200))
                        }
                    }
                }
                .padding(.horizontal, 28)
                .frame(height: 58)
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.dummyProducts.indices, id: \.self) { i in
                        ProductItemView(
                            product: $viewModel.dummyProducts[i],
                            width: productCellWidth,
                            shouldToggleInterestState: {                                
                                return viewModel.canToggleInterestState(
                                    productID: viewModel.dummyProducts[i].id
                                )
                            })
                            .onTapGesture {
                                //TODO: - 화면 전환
                                print("\(viewModel.dummyProducts[i].id)번 상품")
                            }
                    }
                }
                .padding(.horizontal, 28)
            }
            .padding(.bottom, 108)
        }
    }
}

#Preview {
    struct PreviewContainer: View {
        @State private var isGenreSelectModalPresented = false
        
        var body: some View {
            SearchView(isGenreSelectModalPresented: $isGenreSelectModalPresented)
        }
    }
    
    return PreviewContainer()
}
