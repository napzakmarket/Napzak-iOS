//
//  SearchView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/15/25.
//

import SwiftUI

struct SearchView: View {
    
    //MARK: - Property Wrappers
    
    @EnvironmentObject private var navigationRouter: NavigationRouter
    @EnvironmentObject private var tabRouter: TabRouter

    @StateObject var viewModel: SearchViewModel
    
    @State private var scrollToTopTrigger: Bool = false
    
    @Binding var isGenreSelectModalPresented: Bool
    @Binding var isSortModalPresented: Bool

    //MARK: - Properties
    
    private let productCellWidth = (UIScreen.main.bounds.width - 76) / 2
    private let columns = [GridItem(.flexible(), spacing: 20), GridItem(.flexible())]
    
    init(viewModel: SearchViewModel, isGenreSelectModalPresented: Binding<Bool>, isSortModalPresented: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._isGenreSelectModalPresented = isGenreSelectModalPresented
        self._isSortModalPresented = isSortModalPresented
    }
    
    //MARK: - Body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                searchHeader
                    .padding(.top, 75)
                if viewModel.loadingManager.isLoadingNetwork {
                    LoadingView()
                        .padding(.bottom, 180)
                } else {
                    productScrollView(
                        products: viewModel.selectedTabIndex == 0 ? $viewModel.sellProducts : $viewModel.buyProducts,
                        productsCount: viewModel.selectedTabIndex == 0 ? viewModel.sellProductsCount : viewModel.buyProductsCount
                    )
                    Spacer()
                }
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
                    viewModel: GenreSelectModalViewModel(
                        selectedGenres: viewModel.productFetchOption.genres
                    ),
                    isGenreSelectModalPresented: $isGenreSelectModalPresented,
                    adaptedGenres: $viewModel.productFetchOption.genres
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(2)
            }
            
            if isSortModalPresented {
                Color.napzakTransparency(.transBlack)
                    .onTapGesture {
                        withAnimation {
                            isSortModalPresented = false
                        }
                    }
                    .transition(.opacity)
                    .zIndex(1)
                
                SortModalView(
                    isSortModalPresented: $isSortModalPresented,
                    selectedOption: $viewModel.productFetchOption.sortOption
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(2)
            }
            
            if viewModel.showToast {
                ToastMessageView(
                    message: "찜한 상품에 추가되었어요!",
                    style: .success
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(1)
                .padding(.bottom, 110)
            }
        }
        .ignoresSafeArea()
        .toolbar(.hidden, for: .navigationBar)
        .animation(.spring(), value: viewModel.showToast)
        .animation(.easeInOut(duration: 0.3), value: isGenreSelectModalPresented)
        .animation(.easeInOut(duration: 0.3), value: isSortModalPresented)
        .onChange(of: viewModel.selectedTabIndex) { _ in
            Task {
                await viewModel.updateProducts()
            }
            scrollToTopTrigger.toggle()
        }
        .onChange(of: viewModel.productFetchOption) { _ in
            Task {
                await viewModel.updateProducts()
            }
            scrollToTopTrigger.toggle()
        }
        .onChange(of: tabRouter.selectedTab) { tab in
            if tab != .search {
                viewModel.productFetchOption.genres = []
                viewModel.productFetchOption.sortOption = .recent
                scrollToTopTrigger.toggle()
                viewModel.selectedTabIndex = 0
            }
        }
    }
}

extension SearchView {
    
    //MARK: - UI Properties
    
    private var searchHeader: some View {
        VStack(spacing: 0) {
            searchButton
                .padding(.horizontal, 27)
                .padding(.bottom, 19)
            
            ZStack(alignment: .top) {
                shadowBackground
                
                VStack(alignment: .leading, spacing: 0) {
                    NZSegmentedControl(selectedTabIndex: $viewModel.selectedTabIndex, tabs: ["팔아요", "구해요"],  spacing: 16)
                    
                    if !viewModel.loadingManager.isLoadingNetwork {
                        FilterContainerView(
                            isGenreSelectModalPresented: $isGenreSelectModalPresented,
                            selectedTabIndex: $viewModel.selectedTabIndex,
                            selectedGenres: $viewModel.productFetchOption.genres,
                            isUnopened: $viewModel.productFetchOption.isUnopened,
                            isOnSale: $viewModel.productFetchOption.isOnSale
                        )
                        .frame(height: 54)
                    }
                }
                .padding(.horizontal, 28)
            }
        }
    }
    
    private var searchButton: some View {
        Button {
            navigationRouter.push(next: .searchInputView)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.napzakGrayScale(.gray50))
                HStack(spacing: 0) {
                    Text(viewModel.searchWord.isEmpty ? "어떤 상품을 찾고 계신가요?" : viewModel.searchWord)
                        .foregroundStyle(viewModel.searchWord.isEmpty ? Color.napzakGrayScale(.gray200) : Color.napzakGrayScale(.black))
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
            Color.napzakGrayScale(viewModel.loadingManager.isLoadingNetwork ? .white : .gray10)
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
                    let genre = viewModel.productFetchOption.genres[i]
                    let id = genre.id
                    let name = genre.name
                    
                    navigationRouter.push(next: .genreDetailView(genreId: id,
                                                                 genreName: name))
                } label: {
                    GenreItemView(genreName: viewModel.productFetchOption.genres[i].name)
                        .frame(height: 64)
                }
                Color.napzakGrayScale(.gray10)
                    .frame(height: 4)
            }
        }
    }
}

private extension SearchView {
    
    //MARK: - ViewBuilder Func
    
    @ViewBuilder
    private func productScrollView(products: Binding<[ProductItemModel]>, productsCount: Int) -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    Color.clear
                        .frame(height: 0)
                        .id("top")
                    if !viewModel.productFetchOption.genres.isEmpty {
                        genreListView
                    }
                    productsHeader(count: productsCount)
                    productsGrid(products: products)
                }
                .padding(.bottom, 108)
            }
            .onChange(of: scrollToTopTrigger) { _ in
                proxy.scrollTo("top", anchor: .top)
            }
        }
    }
    
    @ViewBuilder
    private func productsHeader(count: Int) -> some View {
        HStack(alignment: .center, spacing: 3) {
            Text("상품")
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .applyNapzakFont(.body5SemiBold14)
            Text("\(count)개")
                .foregroundStyle(Color.napzakPrimary(.purple500))
                .applyNapzakFont(.body5SemiBold14)
            Spacer()
            Button {
                withAnimation {
                    isSortModalPresented = true
                }
            } label: {
                HStack(alignment: .center, spacing: 4) {
                    Text("\(viewModel.productFetchOption.sortOption.title)")
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
    }
    
    @ViewBuilder
    private func productsGrid(products: Binding<[ProductItemModel]>) -> some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(products.indices, id: \.self) { i in
                productGridItem(product: products[i])
            }
        }
        .padding(.horizontal, 28)
    }
    
    @ViewBuilder
    private func productGridItem(product: Binding<ProductItemModel>) -> some View {
        ProductItemView(
            product: product,
            width: productCellWidth,
            isHiddenProductSummary: false,
            shouldToggleInterestState: {
                 viewModel.toggleLike(for: product.wrappedValue.id)
            }
        )
        .onTapGesture {
            print("\(product.wrappedValue.id)번 상품")
            navigationRouter.push(next: .productDetailView(productId: product.wrappedValue.id))
        }
    }
}
