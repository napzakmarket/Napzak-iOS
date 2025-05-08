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
    @StateObject private var viewModel = HomeViewModel()
    @State private var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    private let placeholder: String = "어떤 상품을 찾고 계신가요?"
    private let productCellWidth = (UIScreen.main.bounds.width - 76) / 2
    private let columns = [GridItem(.flexible(), spacing: 20), GridItem(.flexible())]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 0) {
                
                Image(.iconNapzakLogo)
                    .padding(.leading, 28)
                    .padding(.bottom, 17)
                    
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
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
                        
                        Text("개인정보처리방침")
                            .frame(width: UIScreen.main.bounds.width, height: 160)
                            .background(Color.napzakGrayScale(.gray100))
                            .padding(.bottom, 54)
                    }
                }
                .scrollIndicators(.hidden)
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
        }
        .animation(.spring(), value: viewModel.showLikeToast)
    }
}

extension HomeView {
    private var headerView: some View {
        VStack(spacing: 0) {
            Button {
                // TODO: - 검색 뷰 이동
                print("검색 뷰 이동")
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
                                return canToggle
                            }
                        )
                        .onTapGesture {
                            //TODO: - 화면 전환
                            print("\(viewModel.recommendedProducts[index].id)번 상품")
                        }
                    }
                }
            }
        }
    }
    
    private var middleBannerSection: some View {
        BannerItemView(
            banner: viewModel.banners.middleBanner,
            style: .small(cornerRadius: 16)
        ) {
            print("middle배너 눌림")
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
                    // TODO: 인기순 정렬 팔아요 화면 이동
                    viewModel.navigateToSellPopular()
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
                    return canToggle
                },
                onTapProduct: { productId in
                    // TODO: 상품 상세 화면으로 이동
                    print("\(productId)번 상품")
                }
            )
        }
    }
    
    private var bottomBannerSection: some View {
        BannerItemView(
            banner: viewModel.banners.bottomBanner,
            style: .small(cornerRadius: 16)
        ) {
            print("bottom배너 눌림")
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
                    // TODO: 인기순 정렬 구해요 화면 이동
                    viewModel.navigateToBuyPopular()
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
                    return canToggle
                },
                onTapProduct: { productId in
                    // TODO: 상품 상세 화면으로 이동
                    print("\(productId)번 상품")
                }
            )
        }
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
        onToggleLike: @escaping (Int) -> Bool,
        onTapProduct: ((Int) -> Void)? = nil
    ) -> some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(products.wrappedValue.indices, id: \.self) { index in
                ProductItemView(
                    product: products[index],
                    width: cellWidth,
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
    HomeView()
}

