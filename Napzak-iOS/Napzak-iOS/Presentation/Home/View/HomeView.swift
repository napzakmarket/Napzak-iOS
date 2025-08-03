//
//  HomeView.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/26/25.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    @EnvironmentObject private var navigationRouter: NavigationRouter
    @EnvironmentObject private var tabRouter: TabRouter
    @EnvironmentObject private var pushManager: PushManager
    @StateObject private var viewModel = HomeViewModel()
    
    @State private var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    @State private var scrollToTopTrigger: Bool = false
    @Binding var isTabBarHidden: Bool
    
    private let placeholder: String = "어떤 상품을 찾고 계신가요?"
    private let productCellWidth = (UIScreen.main.bounds.width - 76) / 2
    private let columns = [GridItem(.flexible(), spacing: 20), GridItem(.flexible())]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 0) {
                
                Image(.logo)
                    .padding(.leading, 28)
                    .padding(.bottom, 17)
                
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            Color.clear
                                .frame(height: 0)
                                .id("top")
                            headerView
                                .padding(.horizontal, 28)
                            
                            topBannerSection
                                .padding(.top, 21)
                            
                            recommendedSection
                                .padding(.leading, 28)
                                .padding(.top, 21)
                            
                            middleBannerSection
                                .padding(.leading, 28)
                                .padding(.vertical, 40)
                            
                            popularSellSection
                                .padding(.horizontal, 28)
                                .padding(.top, 32)
                                .padding(.bottom, 20)
                                .background(Color.napzakGrayScale(.gray10))
                            
                            bottomBannerSection
                                .padding(.leading, 28)
                                .padding(.vertical, 40)
                            
                            popularBuySection
                                .padding(.horizontal, 28)
                                .padding(.bottom, 20)
                            
                            FooterView
                                .padding(.bottom, 54)
                        
                        }
                    }
                    .scrollIndicators(.hidden)
                    .onChange(of: scrollToTopTrigger) { _ in
                        proxy.scrollTo("top", anchor: .top)
                    }
                }
                
            }
            
            if viewModel.showLikeToast {
                ToastMessageView(
                    message: "찜한 상품에 추가되었어요!",
                    style: .success
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(1)
                .padding(.bottom, 110)
            }
            
            if viewModel.loadingManager.isLoadingNetwork {
                LoadingView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            Task {
                await pushManager.configureNotifications()
                await pushManager.upsertTokenIfNeeded()
            }
        }
        .animation(.spring(), value: viewModel.showLikeToast)
        .onChange(of: viewModel.externalURLToOpen) { url in
            if let url {
                UIApplication.shared.open(url)
                viewModel.externalURLToOpen = nil
            }
        }
        .onChange(of: tabRouter.selectedTab) { tab in
            if tab == .home { 
                viewModel.fetchHomeData()
                scrollToTopTrigger.toggle()
            }
        }
        .onChange(of: viewModel.loadingManager.isLoadingNetwork) { _ in
            if viewModel.loadingManager.isLoadingNetwork {
                isTabBarHidden = true
            } else {
                isTabBarHidden = false
            }
        }
    }
}

extension HomeView {
    private var headerView: some View {
        VStack(spacing: 0) {
            Button {
                navigationRouter.push(next: .searchInputView)
            } label: {
                HStack {
                    Text(placeholder)
                        .applyNapzakFont(.caption2Medium12)
                        .foregroundStyle(Color.napzakGrayScale(.gray200))
                        .padding(.leading, 16)
                    
                    Spacer()
                    
                    Image(.iconSearch)
                        .padding(.vertical, 8)
                        .padding(.trailing, 16)
                }
                .background(Color.napzakGrayScale(.gray50))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
    
    private var topBannerSection: some View {
        CarouselView(
            currentPage: $viewModel.selectedBannerIndex,
            banners: viewModel.banners.topBanners,
            onTapBanner: { banner in
                viewModel.handleBannerTap(banner.action)
            }
        )
    }
    
    private var recommendedSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            setcionHeader(
                title: viewModel.recommendedTitle,
                subtitle: viewModel.recommendedSubtitle
            )
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 8) {
                    ForEach(viewModel.recommendedProducts.indices, id: \.self) { index in
                        ProductItemView(
                            product: $viewModel.recommendedProducts[index],
                            width: 116,
                            isHiddenProductSummary: true,
                            shouldToggleInterestState: {
                                let productId = viewModel.recommendedProducts[index].id
                                let canToggle = viewModel.canToggleInterestState(
                                    productID: productId,
                                    in: .recommended
                                )
                                if canToggle {
                                    viewModel.toggleLike(
                                        for: productId,
                                        in: .recommended
                                    )
                                }
                            }
                        )
                        .onTapGesture {
                            navigationRouter.push(next: .productDetailView(productId: viewModel.recommendedProducts[index].id))
                        }
                    }
                }
                .padding(.trailing, 20)
            }
        }
    }
    
    private var middleBannerSection: some View {
        BannerItemView(
            banner: viewModel.banners.middleBanner,
            style: .small(cornerRadius: 16)
        ) {
            viewModel.handleBannerTap(viewModel.banners.middleBanner.action)
        }
    }
    
    private var popularSellSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            setcionHeader(
                title: viewModel.popularSellTitle,
                subtitle: viewModel.popularSellSubtitle,
                showMore: true,
                onMoreTap: {
                    tabRouter.switchToSearch(searchWord: "", sortOption: .popular, searchTabIndex: 0)
                }
            )
            
            productGrid(
                products: $viewModel.popularSellProducts,
                cellWidth: productCellWidth,
                onToggleLike: { productId in
                    let canToggle = viewModel.canToggleInterestState(
                        productID: productId,
                        in: .popularSell
                    )
                    if canToggle {
                        viewModel.toggleLike(
                            for: productId,
                            in: .popularSell
                        )
                        
                    }
                },
                onTapProduct: { productId in
                    navigationRouter.push(next: .productDetailView(productId: productId))
                }
            )
        }
    }
    
    private var bottomBannerSection: some View {
        BannerItemView(
            banner: viewModel.banners.bottomBanner,
            style: .small(cornerRadius: 16)
        ) {
            viewModel.handleBannerTap(viewModel.banners.bottomBanner.action)
        }
    }
    
    private var popularBuySection: some View {
        VStack(alignment: .leading, spacing: 24) {
            setcionHeader(
                title: viewModel.popularBuyTitle,
                subtitle: viewModel.popularBuySubtitle,
                showMore: true,
                onMoreTap: {
                    tabRouter.switchToSearch(searchWord: "", sortOption: .popular, searchTabIndex: 1)
                }
            )
            
            productGrid(
                products: $viewModel.popularBuyProducts,
                cellWidth: productCellWidth,
                onToggleLike: { productId in
                    let canToggle = viewModel.canToggleInterestState(
                        productID: productId,
                        in: .popularBuy
                    )
                    if canToggle {
                        viewModel.toggleLike(
                            for: productId,
                            in: .popularBuy
                        )
                    }
                },
                onTapProduct: { productId in
                    navigationRouter.push(next: .productDetailView(productId: productId))
                }
            )
        }
    }
    
    private var FooterView: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("납작마켓")
                .applyNapzakFont(.caption1SemiBold12)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .padding(.top, 20)
            
            HStack(spacing: 4) {
                Image(.iconMessage)
                Text(verbatim: "napzakmarket@gmail.com")
                    .applyNapzakFont(.caption5Regular10)
                    .foregroundStyle(Color.napzakGrayScale(.gray300))
                    .textSelection(.enabled)
            }
            .padding(.top, 8)
            
            HStack(spacing: 4) {
                Image(.iconInstagram)
                Text(verbatim: "https://www.instagram.com/napzak_official/")
                    .applyNapzakFont(.caption5Regular10)
                    .foregroundStyle(Color.napzakGrayScale(.gray300))
                    .textSelection(.enabled)
            }
            .padding(.top, 3)
            
            HStack(spacing: 8) {
                Text("서비스 이용 약관")
                    .applyNapzakFont(.caption4SemiBold10)
                    .foregroundStyle(Color.napzakGrayScale(.gray500))
                
                Rectangle()
                    .frame(width: 1, height: 7)
                    .foregroundStyle(Color.napzakGrayScale(.gray200))
                
                Text("개인정보 처리방침")
                    .applyNapzakFont(.caption4SemiBold10)
                    .foregroundStyle(Color.napzakGrayScale(.gray500))
            }
            .padding(.top, 20)
            
            Text("Copyright 2025. NAPZAKmarket All rights reserved.")
                .applyNapzakFont(.caption5Regular10)
                .foregroundStyle(Color.napzakGrayScale(.gray300))
                .padding(.top, 20)
            
            HStack(spacing: 8) {
                Text("대표")
                    .applyNapzakFont(.caption4SemiBold10)
                    .foregroundStyle(Color.napzakGrayScale(.gray300))
                
                Rectangle()
                    .frame(width: 1, height: 7)
                    .foregroundStyle(Color.napzakGrayScale(.gray200))
                
                Text("이해인")
                    .applyNapzakFont(.caption4SemiBold10)
                    .foregroundStyle(Color.napzakGrayScale(.gray300))
            }
            .padding(.top, 8)
            .padding(.bottom, 15)
        }
        .frame(width: UIScreen.main.bounds.width, height: 177)
        .background(Color.napzakGrayScale(.gray10))
    }

}

extension HomeView {
    func setcionHeader(
        title: String,
        subtitle: String,
        showMore: Bool = false,
        onMoreTap: (() -> Void)? = nil
    ) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .applyNapzakFont(.title3Bold18)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            
            HStack {
                Text(subtitle)
                    .applyNapzakFont(.caption2Medium12)
                    .foregroundStyle(Color.napzakGrayScale(.gray300))
                    .fixedSize(horizontal: false, vertical: true)
                
                
                Spacer()
                
                if showMore {
                    Button {
                        onMoreTap?()
                    } label: {
                        HStack(spacing: 4) {
                            Text("자세히보기")
                                .applyNapzakFont(.caption2Medium12)
                                .foregroundStyle(Color.napzakGrayScale(.gray300))
                            
                            Image(.iconHomeNext)
                        }
                    }
                }
            }
        }
    }
    
    func productGrid(
        products: Binding<[ProductItemModel]>,
        cellWidth: CGFloat,
        onToggleLike: @escaping (Int) -> Void,
        onTapProduct: ((Int) -> Void)? = nil
    ) -> some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(products.wrappedValue.indices, id: \.self) { index in
                ProductItemView(
                    product: products[index],
                    width: cellWidth,
                    isHiddenProductSummary: false,
                    shouldToggleInterestState: {
                        onToggleLike(products[index].wrappedValue.id)
                    }
                )
                .onTapGesture {
                    onTapProduct?(products[index].wrappedValue.id)
                }
            }
        }
    }
}

#Preview {
    HomeView(isTabBarHidden: .constant(false))
        .environmentObject(TabRouter())
        .environmentObject(NavigationRouter())
        .environmentObject(PushManager(permission: PushPermissionManager()))
}
