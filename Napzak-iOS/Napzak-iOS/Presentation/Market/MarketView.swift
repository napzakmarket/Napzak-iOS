//
//  MarketView.swift
//  Napzak-iOS
//
//  Created by 어진 on 4/23/25.
//

import SwiftUI

import Kingfisher

struct MarketView: View {
    
    //MARK: - Property Wrappers
    
    @EnvironmentObject private var navigationRouter: NavigationRouter

    @StateObject var viewModel: MarketViewModel
    
    @State private var isGenreSelectModalPresented = false
    @State private var isSortModalPresented = false
    @State private var selectedSortOption: SortOption = .recent
    @State private var isReportModalPresented = false
    @State private var scrollToTopTrigger: Bool = false
    
    //MARK: - Properties

    private let productCellWidth = (UIScreen.main.bounds.width - 76) / 2
    private let columns = [GridItem(.flexible(), spacing: 20), GridItem(.flexible())]
    
    //MARK: - Init
    
    init(storeId: Int) {
        _viewModel = StateObject(wrappedValue: MarketViewModel(storeId: storeId))
    }
    
    //MARK: - Body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                navigationBarView
                mainScrollView
            }
            
            if isGenreSelectModalPresented {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
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
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isSortModalPresented = false
                        }
                    }
                    .transition(.opacity)
                    .zIndex(1)

                ZStack(alignment: .bottom) {
                    SortModalView(
                        isSortModalPresented: $isSortModalPresented,
                        selectedOption: $selectedSortOption
                    )
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(2)
            }
            
            if isReportModalPresented {
                Color.napzakTransparency(.transBlack)
                    .onTapGesture {
                        withAnimation {
                            isReportModalPresented = false
                        }
                    }
                    .transition(.opacity)
                    .zIndex(1)
                
                ReportModalView(
                    isReportModalPresented: $isReportModalPresented,
                    reportType: .store,
                    onReportButtonTapped: {
                        navigationRouter.push(next: .reportView(reportType: .store, id: viewModel.storeDetail?.storeId ?? 0))
                    }
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
                .zIndex(3)
                .padding(.bottom, 110)
            }
            
            if viewModel.loadingManager.isLoadingNetwork {
                LoadingView()
            }
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .animation(.spring(), value: viewModel.showToast)
        .animation(.easeInOut(duration: 0.3), value: isGenreSelectModalPresented)
        .animation(.easeInOut(duration: 0.3), value: isSortModalPresented)
        .onChange(of: viewModel.selectedTabIndex) { _ in
            Task {
                await viewModel.fetchProducts()
                scrollToTopTrigger.toggle()
            }
        }
        .onChange(of: selectedSortOption) { newValue in
            viewModel.productFetchOption.sortOption = newValue
            Task {
                await viewModel.fetchProducts()
                scrollToTopTrigger.toggle()
            }
        }
    }

    private var navigationBarView: some View {
        VStack {
            Spacer()
            HStack() {
                Button {
                    navigationRouter.pop()
                } label: {
                    Image(.iconBack)
                        .frame(width: 48, height: 48)
                }
                Spacer()
                if !(viewModel.storeDetail?.isStoreOwner ?? true) {
                    Button {
                        withAnimation {
                            isReportModalPresented = true
                        }
                    } label: {
                        Image(.iconMoreOptions)
                            .frame(width: 48, height: 48)
                    }
                }
            }
        }
        .frame(height: 96)
        .padding(.bottom, 4)
        .padding(.horizontal, 9)
    }
    
    private var mainScrollView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                profileSectionView
                Color.clear
                    .frame(height: 0)
                    .id("top")
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    Section(header: tabAndFilterSectionView) {
                        contentListView
                    }
                }
            }
            .onChange(of: scrollToTopTrigger) { _ in
                proxy.scrollTo("top")
            }
        }
    }
    
    private var profileSectionView: some View {
        VStack(spacing: 0) {
            ZStack {
                if let storeCover = viewModel.storeDetail?.storeCover, !storeCover.isEmpty {
                    KFImage(URL(string: storeCover))
                        .placeholder {
                            Rectangle()
                                .fill(Color.napzakGrayScale(.gray100))
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(height: 160)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(Color.napzakGrayScale(.gray100))
                        .frame(height: 160)
                }
                
                if let storePhoto = viewModel.storeDetail?.storePhoto, !storePhoto.isEmpty {
                    KFImage(URL(string: storePhoto))
                        .placeholder {
                            Image("profile_market")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.napzakGrayScale(.white), lineWidth: 5)
                                )
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.napzakGrayScale(.white), lineWidth: 5)
                        )
                        .offset(y: 80)
                } else {
                    Image("profile_market")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color.napzakGrayScale(.gray200))
                        .offset(y: 80)
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        // 본인 상점일 경우에만 프로필 편집 버튼 표시
                        if viewModel.storeDetail?.isStoreOwner == true {
                            Button {
                                navigationRouter.push(next: .profileEditView)
                            } label: {
                                Text("프로필 편집")
                                    .foregroundColor(Color.napzakGrayScale(.white))
                                    .applyNapzakFont(.caption4SemiBold10)
                                    .frame(width: 48, height: 12)
                                    .padding(6)
                                    .background(
                                        Capsule()
                                            .fill(Color.napzakGrayScale(.gray400))
                                    )
                            }
                            .padding(.trailing, 28)
                        }
                    }
                    .padding(.bottom, 8)
                }
            }

            VStack(spacing: 0) {
                if viewModel.isLoadingProfile {
                    ProgressView()
                        .padding(.top, 42)
                } else {
                    Text(viewModel.storeDetail?.storeNickName ?? "납작한 자기")
                        .foregroundColor(Color.napzakGrayScale(.gray500))
                        .applyNapzakFont(.body2SemiBold16)
                        .padding(.top, 42)
                    
                    // 소개글이 있을 때만 표시
                    if let description = viewModel.storeDetail?.storeDescription,
                       !description.isEmpty {
                        Text(description)
                            .foregroundColor(Color.napzakGrayScale(.black))
                            .applyNapzakFont(.caption2Medium12)
                            .multilineTextAlignment(.center)
                            .padding(.top, 6)
                            .padding(.horizontal, 37)
                    }
                }

                GeometryReader { geometry in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 5) {
                            if let genres = viewModel.storeDetail?.genrePreferences, !genres.isEmpty {
                                ForEach(genres, id: \.genreId) { genre in
                                    PlainChip(title: genre.genreName.count > 5
                                            ? String(genre.genreName.prefix(5)) + "..."
                                            : genre.genreName)
                                }
                            } else if viewModel.isLoadingProfile {
                                ForEach(["로딩 중..."], id: \.self) { tag in
                                    PlainChip(title: tag)
                                }
                            }
                        }
                        .padding(.horizontal, 25)
                        .padding(.vertical, 2)
                        .frame(minWidth: geometry.size.width, alignment: .center)
                    }
                }
                .frame(height: 50)
                .padding(.top, 17)
                .padding(.bottom, 17)
            }
        }
    }
    
    private var tabAndFilterSectionView: some View {
        ZStack(alignment: .top) {
            if viewModel.selectedTabIndex != 2 {
                ZStack(alignment: .top) {
                    Color.napzakGrayScale(.gray10)
                    Color.napzakGrayScale(.white)
                        .frame(height: 47)
                        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
                }
                .frame(height: 103)
                .clipped()
            } else {
                Color.napzakGrayScale(.white)
                    .frame(height: 47)
                    .overlay(
                        Rectangle()
                            .fill(Color.black.opacity(0.1))
                            .frame(height: 1),
                        alignment: .bottom
                    )
            }

            VStack(alignment: .leading, spacing: 0) {
                NZSegmentedControl(
                    selectedTabIndex: $viewModel.selectedTabIndex,
                    tabs: ["팔아요", "구해요", "리뷰"],
                    spacing: 16
                )

                if viewModel.selectedTabIndex != 2 {
                    FilterContainerView(
                        isGenreSelectModalPresented: $isGenreSelectModalPresented,
                        selectedTabIndex: $viewModel.selectedTabIndex,
                        selectedGenres: $viewModel.productFetchOption.genres,
                        isUnopened: $viewModel.productFetchOption.isUnopened,
                        isOnSale: $viewModel.productFetchOption.isOnSale
                    )
                    .frame(height: 54)
                    .onChange(of: viewModel.productFetchOption) { _ in
                        Task {
                            await viewModel.fetchProducts()
                        }
                    }
                }
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
    
    private var contentListView: some View {
        VStack(spacing: 0) {
            if viewModel.selectedTabIndex == 2 {
                ReviewView
            } else {
                productListView
            }
        }
        .padding(.bottom, 108)
        .background(Color.napzakGrayScale(.white))
    }
    
    private var productListView: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 3) {
                Text("상품")
                    .foregroundStyle(Color.napzakGrayScale(.gray500))
                    .applyNapzakFont(.body5SemiBold14)
                Text("\(viewModel.getProductCount())개")
                    .foregroundStyle(Color.napzakPrimary(.purple500))
                    .applyNapzakFont(.body5SemiBold14)
                Spacer()
                Button {
                    withAnimation {
                        isSortModalPresented = true
                    }
                } label: {
                    HStack(alignment: .center, spacing: 4) {
                        Text(selectedSortOption.title)
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

            if viewModel.isLoadingProducts {
                ProgressView()
                    .padding(.top, 40)
            } else if viewModel.products.isEmpty {
                VStack {
                    Spacer()
                        .frame(height: 40)
                    Text("상품이 없습니다")
                        .foregroundColor(Color.napzakGrayScale(.gray300))
                        .applyNapzakFont(.body1Bold16)
                    Spacer()
                }
                .frame(height: 200)
            } else {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.products.indices, id: \.self) { i in
                        ProductItemView(
                            product: $viewModel.products[i],
                            width: productCellWidth,
                            isHiddenProductSummary: false,
                            shouldToggleInterestState: {
                                 viewModel.toggleLike(for: viewModel.products[i].id)
                            })
                        .onTapGesture {
                           navigationRouter.push(next: .productDetailView(productId: viewModel.products[i].id))
                           print("\(viewModel.products[i].id)번 상품")
                       }
                    }
                }
                .padding(.horizontal, 28)
            }
        }
    }
    
    private var ReviewView: some View {
        VStack(spacing: 16) {
            Spacer()
                .frame(height: 100)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
