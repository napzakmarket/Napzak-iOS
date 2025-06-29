//
//  LikeView.swift
//  Napzak-iOS
//
//  Created by 어진 on 6/25/25.
//

import SwiftUI

struct LikeView: View {
        
    @EnvironmentObject private var navigationRouter: NavigationRouter
    @EnvironmentObject private var tabRouter: TabRouter
    
    @StateObject var viewModel: LikeViewModel
    
    @State private var scrollToTopTrigger: Bool = false
    @State private var selectedTabIndex: Int = 0
        
    private let productCellWidth = (UIScreen.main.bounds.width - 76) / 2
    private let columns = [GridItem(.flexible(), spacing: 20), GridItem(.flexible())]
    
    init() {
        self._viewModel = StateObject(wrappedValue: LikeViewModel())
    }
        
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                likeHeader
                productScrollView
                Spacer()
            }
            
            if viewModel.showToast {
                ToastMessageView(
                    message: "찜한 상품에서 추가되었어요!",
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
        .onChange(of: selectedTabIndex) { _ in
            viewModel.updateProducts()
            scrollToTopTrigger.toggle()
        }
        .onAppear {
            viewModel.loadLikedProducts()
        }
    }
}

extension LikeView {
        
    private var likeHeader: some View {
        VStack(spacing: 0) {
            headerTitle
            ZStack(alignment: .top) {
                shadowBackground
                
                VStack(alignment: .leading, spacing: 0) {
                    NZSegmentedControl(
                        selectedTabIndex: $selectedTabIndex,
                        tabs: ["팔아요", "구해요"],
                        spacing: 16
                    )
                }
                .padding(.horizontal, 28)
                .frame(height: 47)
                .padding(.bottom,20)
            }
        }
    }
    
    private var headerTitle: some View {
        VStack(alignment: .leading) {
            Button {
                navigationRouter.pop()
            } label: {
                HStack(alignment: .center, spacing: 0) {
                    Image(.iconBack)
                        .padding(.trailing,4)
                        .frame(width: 24, height: 24)
                    Text("찜")
                        .applyNapzakFont(.body1Bold16)
                        .foregroundStyle(Color.napzakGrayScale(.gray400))
                        .frame(height: 20)
                }
            }
            .padding(.bottom, 6)
            .padding(.top, 58)
            .padding(.leading, 20)
            
            Divider()
        }
        .padding(.bottom, 6)
        .background(.white)
    }
    
    private var shadowBackground: some View {
        ZStack(alignment: .top) {
            Color.napzakGrayScale(.gray10)
            Color.napzakGrayScale(.white)
                .frame(height: 47)
                .shadow(color: .black.opacity(0.1), radius: 4)
        }
        .frame(height: 47)
        .clipped()
    }
    
    private var productScrollView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    Color.clear
                        .frame(height: 0)
                        .id("top")
                    
                    if currentProducts.isEmpty {
                        emptyStateView
                    } else {
                        productsGrid
                    }
                }
                .padding(.bottom, 108)
            }
            .onChange(of: scrollToTopTrigger) { _ in
                proxy.scrollTo("top", anchor: .top)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image("LikeNone")
            
            VStack(spacing: 8) {
                Text("아직 찜한 소장품이 없어요")
                    .foregroundStyle(Color.napzakGrayScale(.gray300))
                    .applyNapzakFont(.body1Bold16)

                Text("마음에 드는 아이템을 저장해보세요")
                    .foregroundStyle(Color.napzakGrayScale(.gray200))
                    .applyNapzakFont(.caption1SemiBold12)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 172)
    }
    
    private var productsGrid: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(currentProducts.indices, id: \.self) { i in
                productGridItem(index: i)
            }
        }
        .padding(.horizontal, 28)
    }
    
    private var currentProducts: [ProductItemModel] {
        selectedTabIndex == 0 ? viewModel.sellProducts : viewModel.buyProducts
    }
    
    private var currentProductsCount: Int {
        currentProducts.count
    }
}

private extension LikeView {
        
    @ViewBuilder
    private func productGridItem(index: Int) -> some View {
        let product = currentProducts[index]
        
        ProductItemView(
            product: .constant(product),
            width: productCellWidth,
            isHiddenProductSummary: false,
            shouldToggleInterestState: {
                viewModel.toggleLike(for: product.id)
            }
        )
        .onTapGesture {
            print("\(product.id)번 상품")
            navigationRouter.push(next: .productDetailView(productId: product.id))
        }
    }
}

struct LikeView_Previews: PreviewProvider {
    static var previews: some View {
        LikeView()
            .environmentObject(NavigationRouter())
            .environmentObject(TabRouter())
    }
}
