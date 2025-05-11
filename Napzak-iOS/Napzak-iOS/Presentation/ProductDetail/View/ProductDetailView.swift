//
//  ProductDetailView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 5/6/25.
//

import SwiftUI

import Kingfisher

struct ProductDetailView: View {
    
    //MARK: - Property Wrappers
    
    @StateObject var viewModel: ProductDetailViewModel
    
    @EnvironmentObject private var navigationRouter: NavigationRouter

    @State private var currentPage = 0
    @State private var isReportModalPresented = false
    @State private var isOwnerOptionsModalPresented = false

    //MARK: - Properties
    
    let screenWidth = UIScreen.main.bounds.width
    
    private let maxPrice: Int = 1_000_000
    
    //MARK: - Main Body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            mainScrollView
            VStack(spacing: 0) {
                navigationBar
                Spacer()
                if !(viewModel.product.productDetail.isOwnedByCurrentUser) {
                    VStack(spacing: 52) {
                        if viewModel.showToast {
                            ToastMessageView(
                                message: "찜한 상품에 추가되었어요!",
                                style: .success
                            )
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .zIndex(1)
                        }
                        bottomView
                    }
                }
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
                    reportType: .product
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(2)
            }
            
            if isOwnerOptionsModalPresented {
                Color.napzakTransparency(.transBlack)
                    .onTapGesture {
                        withAnimation {
                            isOwnerOptionsModalPresented = false
                        }
                    }
                    .transition(.opacity)
                    .zIndex(1)
                
                ProductOwnerOptionsModalView(
                    isOwnerOptionsModalPresented: $isOwnerOptionsModalPresented,
                    currentStatus: $viewModel.product.productDetail.tradeStatus,
                    tradeType: viewModel.product.productDetail.tradeType
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(2)
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
        .animation(.spring(), value: viewModel.showToast)
        .animation(.easeInOut(duration: 0.3), value: isReportModalPresented)
        .animation(.easeInOut(duration: 0.3), value: isOwnerOptionsModalPresented)
    }
}

extension ProductDetailView {
    
    //MARK: - UI Properties
    
    private var navigationBar: some View {
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
                Button {
                    if viewModel.product.productDetail.isOwnedByCurrentUser {
                            isOwnerOptionsModalPresented  = true
                    } else {
                        isReportModalPresented = true
                    }
                } label: {
                    Image(.iconMoreOptions)
                        .frame(width: 48, height: 48)
                }
            }
        }
        .frame(height: 100)
        .padding(.bottom, 4)
        .padding(.horizontal, 9)
        .background(
            Color.napzakGrayScale(.white)
                .shadow(color: .black.opacity(0.1), radius: 2)
        )
    }
    
    private var mainScrollView: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                productImagePageView
                productInfo
                VStack(spacing: 4) {
                    productDescription
                    if viewModel.product.productDetail.tradeType == .sell {
                        productConditions
                        productDeliveryFee
                    } else {
                        biddingView
                    }
                    marketInfo
                }
                .background(Color.napzakGrayScale(.gray50))
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    private var productImagePageView: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $currentPage) {
                ForEach(Array(viewModel.product.productPhotoList.enumerated()), id: \.1.id) { index, photo in
                    Group {
                        if let url = URL(string: photo.photoUrl) {
                            KFImage(url)
                                .placeholder {
                                    Rectangle()
                                        .fill(Color.napzakGrayScale(.gray300))
                                }.retry(maxCount: 3, interval: .seconds(3))
                                .onFailure { error  in
                                    print("failure: \(error.localizedDescription)")
                                }
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            Rectangle()
                                .fill(Color.napzakGrayScale(.gray300))
                        }
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(width: screenWidth, height: screenWidth * 16 / 15)
            .padding(.bottom, 22)

            Text("\(currentPage + 1)/\(viewModel.product.productPhotoList.count)")
                .applyNapzakFont(.caption5Regular10)
                .foregroundStyle(Color.napzakGrayScale(.white))
                .frame(height: 14)
                .padding(.horizontal, 11)
                .padding(.vertical, 3)
                .background(
                    Color.napzakTransparency(.transBlack)
                        .clipShape(Capsule())
                )
                .padding(.trailing, 29)
                .padding(.bottom, 42)
            
            if viewModel.product.productDetail.tradeStatus != .beforeTrade {
                tradeStatusOverlay
                    .frame(width: screenWidth, height: screenWidth * 16 / 15)
                    .padding(.bottom, 22)
            }
            
            shadowView
                .frame(height: 22)
        }
        .frame(width: screenWidth, height: screenWidth * 16 / 15 + 22)
        .clipped()
        .padding(.top, 100)
    }
    
    private var tradeStatusOverlay: some View {
        ZStack {
            Color.napzakTransparency(.transBlack)
            VStack(spacing: 6) {
                if viewModel.product.productDetail.tradeStatus == .completed {
                    Image(viewModel.product.productDetail.tradeType == .sell ? .imgTradeSellBig : .imgTradeBuyBig)
                    Text(viewModel.product.productDetail.tradeType == .sell ? "판매 완료" : "구매 완료")
                        .applyNapzakFont(.title4SemiBold20)
                        .foregroundStyle(Color.napzakGrayScale(.white))
                } else if viewModel.product.productDetail.tradeStatus == .reserved {
                    Image(.imgTradeReservedBig)
                    Text("예약중")
                        .applyNapzakFont(.title4SemiBold20)
                        .foregroundStyle(Color.napzakGrayScale(.white))
                }
            }
        }
    }
    
    private var shadowView: some View {
        Color.napzakGrayScale(.white)
            .background(
                Color.napzakGrayScale(.white)
                    .shadow(color: .black.opacity(0.1), radius: 2)
            )
    }
        
    private var productInfo: some View {
        VStack(alignment: .leading, spacing: 0){
            productHeader
            Text("\(viewModel.product.productDetail.genreName)")
                .frame(height: 18)
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(Color.napzakGrayScale(.black))
                .padding(.bottom, 10)
            Text("\(viewModel.product.productDetail.productName)")
                .applyNapzakFont(.title6Medium18)
                .foregroundStyle(Color.napzakGrayScale(.black))
                .padding(.bottom, 10)
            Text(formatPrice(price: viewModel.product.productDetail.price))
                .applyNapzakFont(.title3Bold18)
                .foregroundStyle(Color.napzakGrayScale(.black))
                .padding(.bottom, 20)
            Text(viewModel.product.productDetail.uploadTime)
                .frame(height: 15)
                .applyNapzakFont(.caption3Regular12)
                .foregroundStyle(Color.napzakGrayScale(.gray300))
        }
        .padding(.horizontal, 28)
    }
    
    private var productHeader: some View {
        HStack(alignment: .top, spacing: 0) {
            viewModel.product.productDetail.tradeType == .buy ? Image(.imgBuyTag) : Image(.imgSellTag)
            if viewModel.product.productDetail.isPriceNegotiable {
                Image(.imgBiddingTag)
                    .padding(.leading, 4)
            }
            Spacer()
            HStack(alignment: .bottom, spacing: 2) {
                Image(.icnChatCount)
                Text("\(viewModel.product.productDetail.chatCount)")
                    .applyNapzakFont(.caption5Regular10)
                    .foregroundStyle(Color.napzakGrayScale(.gray100))
                    .frame(height: 13)
                Image(.icnHeartCount)
                    .padding([.leading, .bottom], 1)
                Text("\(viewModel.product.productDetail.interestCount)")
                    .applyNapzakFont(.caption5Regular10)
                    .foregroundStyle(Color.napzakGrayScale(.gray100))
                    .frame(height: 13)
            }
        }
        .padding(.bottom, 16)
    }
    
    private var productDescription: some View {
        ZStack(alignment: .top) {
            Color.napzakGrayScale(.white)
            Text("\(viewModel.product.productDetail.description)".forceCharWrapping)
                .applyNapzakFont(.caption3Regular12)
                .foregroundStyle(Color.napzakGrayScale(.black))
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 28)
                .padding(.top, 32)
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            shadowView
                .frame(height: 16)
        }
        .clipped()
    }
    
    private var biddingView: some View {
        HStack(alignment: .center) {
            Text("가격 제시")
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
            Spacer()
            Text(viewModel.product.productDetail.isPriceNegotiable ? "받음" : "받지않음")
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(Color.napzakGrayScale(.gray300))
        }
        .frame(height: 70)
        .padding(.horizontal, 28)
        .background(
            Color.napzakGrayScale(.white)
                .frame(maxWidth: .infinity)
        )
    }
    
    private var productConditions: some View {
        HStack(alignment: .center) {
            Text("상품 상태")
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
            Spacer()
            switch viewModel.product.productDetail.productCondition {
            case .new:
                Image(.imgConditionNew)
            case .likeNew:
                Image(.imgConditionLikeNew)
            case .slightlyUsed:
                Image(.imgConditionSlightlyUsed)
            case .used:
                Image(.imgConditionUsed)
            case .none:
                EmptyView()
            }
        }
        .frame(height: 70)
        .padding(.horizontal, 28)
        .background(
            Color.napzakGrayScale(.white)
                .frame(maxWidth: .infinity)
        )
    }
    
    private var productDeliveryFee: some View {
        HStack(alignment: .top) {
            Text("배송비")
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
            Spacer()
            if ((viewModel.product.productDetail.isDeliveryIncluded) == true) {
                Text("포함")
                    .applyNapzakFont(.body4Bold14)
                    .foregroundStyle(Color.napzakGrayScale(.gray300))
            } else {
                VStack(alignment: .trailing, spacing: 12) {
                    if viewModel.product.productDetail.standardDeliveryFee != 0 {
                        Text("일반택배 \(formatPrice(price: viewModel.product.productDetail.standardDeliveryFee))")
                            .applyNapzakFont(.body4Bold14)
                            .foregroundStyle(Color.napzakGrayScale(.gray300))
                    }
                    if viewModel.product.productDetail.halfDeliveryFee != 0 {
                        Text("반값/알뜰택배 \(formatPrice(price: viewModel.product.productDetail.halfDeliveryFee))")
                            .applyNapzakFont(.body4Bold14)
                            .foregroundStyle(Color.napzakGrayScale(.gray300))
                   }
                }
            }
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 26)
        .background(
            Color.napzakGrayScale(.white)
                .frame(maxWidth: .infinity)
        )
    }
    
    private var marketInfo: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("마켓 정보")
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
            HStack(alignment: .center, spacing: 0) {
                Image(.profileImg)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .padding(.trailing, 14)
                VStack(alignment: .leading) {
                    Text("\(viewModel.product.storeInfo.nickname)")
                        .applyNapzakFont(.body4Bold14)
                        .foregroundStyle(Color.napzakPrimary(.purple500))
                    HStack(alignment: .center, spacing: 0) {
                        Text("팔아요")
                            .applyNapzakFont(.caption2Medium12)
                            .foregroundStyle(Color.napzakGrayScale(.gray500))
                            .padding(.trailing, 2)
                        Text("\(viewModel.product.storeInfo.totalSellCount)개")
                            .applyNapzakFont(.caption1SemiBold12)
                            .foregroundStyle(Color.napzakGrayScale(.gray500))
                            .padding(.trailing, 14)
                        Text("구해요")
                            .applyNapzakFont(.caption2Medium12)
                            .foregroundStyle(Color.napzakGrayScale(.gray500))
                            .padding(.trailing, 2)
                        Text("\(viewModel.product.storeInfo.totalBuyCount)개")
                            .applyNapzakFont(.caption1SemiBold12)
                            .foregroundStyle(Color.napzakGrayScale(.gray500))
                    }
                }
                Spacer()
                Button {
                    
                } label: {
                    Image(.iconArrowRight)
                }
                .frame(width: 22, height: 30)
            }
            .padding(.vertical, 17)
            .padding(.horizontal, 22)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.napzakGrayScale(.gray10))
            )
        }
        .padding(.top, 31)
        .padding(.horizontal, 28)
        .padding(.bottom, viewModel.product.productDetail.isOwnedByCurrentUser ? 62 : 130)
        .background(
            Color.napzakGrayScale(.white)
                .frame(maxWidth: .infinity)
        )
    }
    
    private var bottomView: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 16) {
                Button {
                    viewModel.toggleInterestState()
                } label: {
                    viewModel.product.isInterested ? Image(.btnHeartSelectedBig) : Image(.btnHeartDefaultBig)
                }
                Button {
                    
                } label: {
                    HStack(spacing: 5) {
                        Text("채팅하기")
                            .applyNapzakFont(.caption1SemiBold12)
                            .foregroundStyle(Color.napzakGrayScale(.white))
                        Image(.iconArrowRightWhite)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.napzakPrimary(.purple500))
                )
            }
            .frame(height: 50)
            .padding(.top, 24)
            .padding(.horizontal, 27)
            .padding(.bottom, 34)
        }
        .background(
            Color.napzakGrayScale(.white)
                .shadow(color: .black.opacity(0.1), radius: 2)
        )
    }
}

private extension ProductDetailView {
    
    //MARK: - Private Func
    
    func formatPrice(price: Int) -> String {
        return viewModel.product.productDetail.tradeType == .sell
        ? "\(String(price).convertPrice(maxPrice: maxPrice))원"
        : "\(String(price).convertPrice(maxPrice: maxPrice))원대"
    }
}

#Preview {
    ProductDetailView(viewModel: ProductDetailViewModel(productId: 1))
}
