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
    @Environment(\.openURL) private var openURL
    @StateObject private var viewModel = HomeViewModel()
    
    @State private var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    @State private var scrollToTopTrigger: Bool = false
    @Binding var isTabBarHidden: Bool
    
    private let mixpanelManager = MixpanelManager.shared
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
        .ignoresSafeArea(edges: .bottom)
        .task {
            await pushManager.configureNotifications()
            await pushManager.upsertTokenIfNeeded()
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
                Task {
                    await viewModel.fetchAllInitialData()
                }
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
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 10)
                }
                .frame(height: 39)
                .background(Color.napzakGrayScale(.gray50))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        
    }
    
    private var topBannerSection: some View {
        CarouselView(
            currentPage: $viewModel.selectedBannerIndex,
            banners: viewModel.banners.topBanners,
            onTapBanner: { banner, bannerIndex in
                viewModel.handleBannerTap(banner.action)
                mixpanelManager.trackEvent(event: "Clicked Banner", properties: ["banner_id": banner.id,
                                                                                 "banner_type": "main",
                                                                                 "banner_index": bannerIndex%3])
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
                            mixpanelManager.trackEvent(
                                event: "Clicked custom genre",
                                properties: [
                                    "item_index": index,
                                    "genre_name": viewModel.recommendedProducts[index].genreName,
                                    "post_id": viewModel.recommendedProducts[index].id
                                ]
                            )

                            mixpanelManager.trackEvent(
                                event: "Viewed Product",
                                properties: [
                                    "post_id": viewModel.recommendedProducts[index].id,
                                    "post_type": viewModel.recommendedProducts[index].tradeType.mixpanelName,
                                    "source": "home_feed"
                                ]
                            )
                            
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
            mixpanelManager.trackEvent(event: "Clicked Banner", properties: ["banner_id": viewModel.banners.middleBanner.id,
                                                                             "banner_type": "mini",
                                                                             "banner_index": 1])
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
                    mixpanelManager.trackEvent(event: "Viewed Popular For Sale", properties: ["sort": "popular",
                                                                                              "from": "home"])
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
                    
                    mixpanelManager.trackEvent(
                        event: "Viewed Product",
                        properties: [
                            "post_id": productId,
                            "post_type": "for_sale",
                            "source": "home_feed"
                        ]
                    )
                    
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
            mixpanelManager.trackEvent(event: "Clicked Banner", properties: ["banner_id": viewModel.banners.bottomBanner.id,
                                                                             "banner_type": "mini",
                                                                             "banner_index": 2])
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
                    mixpanelManager.trackEvent(event: "Viewed Popular Wanted", properties: ["sort": "popular",
                                                                                            "from": "home"])
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
                    
                    mixpanelManager.trackEvent(
                        event: "Viewed Product",
                        properties: [
                            "post_id": productId,
                            "post_type": "wanted",
                            "source": "home_feed"
                        ]
                    )
                    
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
                Button {
                    if let url = URL(string: viewModel.termsUrl) {
                        openURL(url)
                    }
                    print("서비스 이용 약관 Tapped")
                } label: {
                    Text("서비스 이용 약관")
                        .applyNapzakFont(.caption4SemiBold10)
                        .foregroundStyle(Color.napzakGrayScale(.gray500))
                }
                
                Rectangle()
                    .frame(width: 1, height: 7)
                    .foregroundStyle(Color.napzakGrayScale(.gray200))
                
                Button {
                    if let url = URL(string: viewModel.privacyUrl) {
                        openURL(url)
                    }
                    print("개인정보 처리방침 Tapped")
                } label: {
                    Text("개인정보 처리방침")
                        .applyNapzakFont(.caption4SemiBold10)
                        .foregroundStyle(Color.napzakGrayScale(.gray500))
                }
                
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
        .frame(width: UIScreen.main.bounds.width)
        .padding(.bottom, 108)
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
