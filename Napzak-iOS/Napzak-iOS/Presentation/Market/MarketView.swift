//
//  MarketView.swift
//  Napzak-iOS
//
//  Created by 어진 on 4/23/25.
//

import SwiftUI

struct MarketView: View {
    
    @StateObject private var viewModel = SearchViewModel()
    
    private let productCellWidth = (UIScreen.main.bounds.width - 76) / 2
    private let columns = [GridItem(.flexible(), spacing: 20), GridItem(.flexible())]
    
    var body: some View {
        VStack(spacing: 0) {
            navBarView
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    profileSectionView
                    tabAndFilterSectionView
                    productListView
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationBarHidden(true)
    }
}

extension MarketView {
    private var navBarView: some View {
        HStack {
            Button {
                //TODO: - 뒤로가기
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.napzakGrayScale(.gray200))
                    .frame(width: 24, height: 24)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(Color.napzakGrayScale(.white))
    }
    
    private var profileSectionView: some View {
        VStack(spacing: 0) {
            ZStack {
                Rectangle()
                    .fill(Color.napzakGrayScale(.gray50))
                    .frame(height: 160)
                
                Image("profile_market")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color.napzakGrayScale(.gray200))
                    .offset(y: 80)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            // TODO: 프로필 편집
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
                    .padding(.bottom, 8)
                }
                .frame(height: 160)
            }

            VStack(spacing: 0) {
                Text("납작한 자기")
                    .foregroundColor(Color.napzakGrayScale(.gray500))
                    .applyNapzakFont(.body2SemiBold16)
                    .padding(.top, 42)

                Text("잡덕입니다. 최애는 짱구, 철수, 흰둥이, 긴토키, 히지카타 관련 상품 판매 및 구매 제시 채팅 언제든 환영합니다 :)")
                    .foregroundColor(Color.napzakGrayScale(.black))
                    .applyNapzakFont(.caption2Medium12)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.top, 6)

            ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 5) {
                        ForEach(["산리오", "은혼", "주술회전", "원피스", "귀멸의 칼날", "시카모머시기"], id: \.self) { tag in
                            Text(tag)
                                .foregroundColor(Color.napzakPrimary(.purple500))
                                .applyNapzakFont(.caption1SemiBold12)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 8)
                                .background(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 50)
                                        .stroke(Color.napzakPrimary(.purple500), lineWidth: 1)
                                )
                                .cornerRadius(50)
                        }
                    }
                    .padding(.horizontal, 25)
                }
                .padding(.top, 16)
                .padding(.bottom, 17)
            }
        }
    }
    
    private var tabAndFilterSectionView: some View {
        ZStack(alignment: .top) {
            shadowBackground
            
            VStack(alignment: .leading, spacing: 0) {
                NZSegmentedControl(selectedTabIndex: $viewModel.selectedTabIndex, tabs: ["팔아요", "구해요", "리뷰"], spacing: 16)
                
                if viewModel.selectedTabIndex != 2 {
                    FilterContainerView(selectedTabIndex: $viewModel.selectedTabIndex,
                                       selectedGenres: $viewModel.productFetchOption.genres,
                                       isUnopened: $viewModel.productFetchOption.isUnopened,
                                       isOnSale: $viewModel.productFetchOption.isOnSale)
                        .frame(height: 54)
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
    
    private var productListView: some View {
        VStack(spacing: 0) {
            if viewModel.selectedTabIndex == 2 {
                Text("")
            } else {
                HStack(alignment: .center, spacing: 3) {
                    Text("상품")
                        .foregroundStyle(Color.napzakGrayScale(.gray500))
                        .applyNapzakFont(.body5SemiBold14)
                    Text("00개")
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
        }
        .padding(.bottom, 108)
        .background(Color.napzakGrayScale(.white))
    }
}

#Preview {
    MarketView()
}
