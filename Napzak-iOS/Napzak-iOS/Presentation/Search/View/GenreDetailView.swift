//
//  GenreDetailView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/29/25.
//

import SwiftUI

import Kingfisher

struct GenreDetailView: View {
    
    //MARK: - Property Wrappers

    @EnvironmentObject private var navigationRouter: NavigationRouter

    @ObservedObject var viewModel: GenreDetailViewModel
    
    @State private var selectedTabIndex = 0
    @State private var isSortModalPresented = false
    
    //MARK: - Properties
    
    private let screenWidth = UIScreen.main.bounds.width
    private let columns = [GridItem(.flexible(), spacing: 20), GridItem(.flexible())]
    private let productCellWidth = (UIScreen.main.bounds.width - 76) / 2

    //MARK: - Body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                navigationHeader
                mainScrollView
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
        .animation(.spring(), value: viewModel.showToast)
        .animation(.easeInOut(duration: 0.3), value: isSortModalPresented)
        .ignoresSafeArea()
        .toolbar(.hidden, for: .navigationBar)
        .onChange(of: selectedTabIndex) { value in
            Task {
                if value == 0 {
                    await viewModel.fetchSellProducts()
                } else {
                    await viewModel.fetchBuyProducts()
                }
            }
        }
        .onChange(of: viewModel.productFetchOption) { value in
            Task {
                if selectedTabIndex == 0 {
                    await viewModel.fetchSellProducts()
                } else {
                    await viewModel.fetchBuyProducts()
                }
            }
        }
    }
}

private extension GenreDetailView {
    
    //MARK: - UI Properties
    
    var navigationHeader: some View {
        HStack(spacing: 4) {
            Button {
                navigationRouter.pop()
            } label: {
                Image(.iconBack)
                    .frame(width: 24, height: 24)
            }
            
            Button {
                navigationRouter.reset()
            } label: {
                Image(.iconHome)
                    .frame(width: 24, height: 24)
            }
            
            Spacer()
        }
        .padding(.leading, 21)
        .padding(.top, 58)
        .padding(.bottom, 18)
        .background(Color.napzakGrayScale(.white))
    }
    
    var mainScrollView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                genreInfoView
                Section(header: segmentedFilterSectionView) {
                    productsView(
                        products: selectedTabIndex == 0 ? $viewModel.sellProducts : $viewModel.buyProducts,
                        productsCount: selectedTabIndex == 0 ? viewModel.sellProductsCount : viewModel.buyProductsCount
                    )
                }
            }
        }
    }
    
    var genreInfoView: some View {
        VStack(alignment: .leading) {
            genreCoverView
                .padding(.bottom, 20)
            
            Group {
                HStack(spacing: 4) {
                    Image(.imgGenreTag)
                    if let _ = viewModel.genreInfo.tag {
                        Image(.imgHotTag)
                    }
                }
                
                Text(viewModel.genreInfo.genreName)
                    .applyNapzakFont(.title2Bold20)
                    .foregroundStyle(Color.napzakGrayScale(.gray500))
                    .frame(height: 26)
            }
            .padding(.leading, 28)
            .padding(.bottom, 14)
        }
    }
    
    var genreCoverView: some View {
        ZStack(alignment: .bottom) {
            if let url = URL(string: viewModel.genreInfo.coverImageUrl) {
                KFImage(url)
                    .placeholder {
                        Rectangle()
                            .fill(Color.napzakGrayScale(.gray100))
                    }
                    .retry(maxCount: 3, interval: .seconds(5))
                    .onFailure { error  in
                        print("failure: \(error.localizedDescription)")
                    }
                    .resizable()
                    .scaledToFill()
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.napzakGrayScale(.gray100))
            }
            
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.napzakGrayScale(.black),
                    Color.napzakGrayScale(.black).opacity(0)
                ]),
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: screenWidth / 3)
            .allowsHitTesting(false)
        }
        .frame(width: screenWidth, height: screenWidth / 9 * 10)
    }
    
    var segmentedFilterSectionView: some View {
        ZStack(alignment: .top) {
            shadowBackground
            
            VStack(alignment: .leading, spacing: 0) {
                NZSegmentedControl(selectedTabIndex: $selectedTabIndex, tabs: ["팔아요", "구해요"],  spacing: 16)
                
                filterView
                    .frame(height: 54)
            }
            .padding(.horizontal, 28)
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
    
    private var filterView: some View {
        HStack(alignment: .center, spacing: 6) {
            if selectedTabIndex == 0 {
                unopenedFilterChip
            }
            onSaleFilterChip
            Spacer()
        }
        .frame(height: 28)
        .frame(maxWidth: 275)
    }
    
    var unopenedFilterChip: some View {
        Button {
            viewModel.productFetchOption.isUnopened.toggle()
        } label: {
            Image(viewModel.productFetchOption.isUnopened ? .btnFilterUnopenedSelected : .btnFilterUnopened)
        }
    }

    var onSaleFilterChip: some View {
        Button {
            viewModel.productFetchOption.isOnSale.toggle()
        } label: {
            Image(viewModel.productFetchOption.isOnSale ? .btnFilterOnSaleSelected : .btnFilterOnSale)
        }
    }
}

private extension GenreDetailView {
    
    //MARK: - ViewBuilder Func
    
    @ViewBuilder
    private func productsView(products: Binding<[ProductItemModel]>, productsCount: Int) -> some View {
        VStack(spacing: 0) {
            productsHeader(count: productsCount)
            productsGrid(products: products)
                .padding(.bottom, 108)
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
            shouldToggleInterestState: {
                Task {
                    await viewModel.toggleLike(for: product.wrappedValue.id)
                }
            }
        )
        .onTapGesture {
            navigationRouter.push(next: .productDetailView(productId: product.wrappedValue.id))
            print("\(product.wrappedValue.id)번 상품")
        }
    }
}

#Preview {
    struct PreviewContainer: View {
        @State private var isSortModalPresented = false
        
        var body: some View {
            GenreDetailView(
                viewModel: GenreDetailViewModel(genreId: 1, genreName: "사카모토 데이즈")
            )
        }
    }
    
    return PreviewContainer()
}
