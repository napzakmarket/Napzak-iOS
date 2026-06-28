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
    @EnvironmentObject private var phoneVerificationManager: PhoneVerificationManager

    @State private var currentPage = 0
    @State private var isReportModalPresented = false
    @State private var isOwnerOptionsModalPresented = false
    @State private var isDeleteAlertPresented = false
    @State private var toastType: ToastType = .productStatusChanged(statusString: "")
    @State private var isRegisterViewPresented = false
    @State private var isImageDetailViewPresented: Bool = false
    @State private var isEditCompleted = false
    @State private var isShareSheetPresented = false

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
                        if viewModel.showInterestToast {
                            ToastMessageView(
                                style: .success
                            )
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .zIndex(1)
                        }
                        
                        if viewModel.showCopyToast {
                            ToastMessageView(
                                style: .share
                            )
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .zIndex(1)
                        }
                        bottomView
                    }
                }
            }
            
            if viewModel.isTooltipPresented {
                VStack {
                    HStack {
                        Spacer()
                        Image(.imgTradeStateTooltip)
                    }
                    .padding(.top, 94)
                    Spacer()
                }
                .padding(.trailing, 16)
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
                
                DetailOptionsModalView(
                    isReportModalPresented: $isReportModalPresented,
                    type: .product,
                    onReportButtonTapped: {
                        navigationRouter.push(next: .reportView(reportType: .product, id: viewModel.product.productDetail.id))
                        MixpanelManager.shared.trackEvent(event: "Opened Report Overlay_product")
                    }
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
                    currentToastType: $toastType,
                    tradeType: viewModel.product.productDetail.tradeType,
                    onEditProduct: {
                        isRegisterViewPresented = true
                    },
                    onChangeStatus: {
                        Task {
                            await viewModel.changeTradeStatus()
                        }
                    },
                    onDeletePtoduct: {
                        isDeleteAlertPresented = true
                    }
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(2)
            }
            
            if isDeleteAlertPresented {
                ZStack(alignment: .center) {
                    Color.napzakTransparency(.transBlack)
                        .onTapGesture {
                            withAnimation {
                                isDeleteAlertPresented = false
                            }
                        }
                        .transition(.opacity)
                    
                    NZAlertView(
                        style: .warning,
                        titleMessage: "상품을 정말 삭제할까요?",
                        subTitleMessage: "한번 삭제한 상품은 다시 되돌릴 수 없어요.",
                        confirmText: "예",
                        cancelText: "아니요",
                        onConfirm: {
                            isDeleteAlertPresented = false
                            Task {
                                await viewModel.deleteProduct()
                                try? await Task.sleep(for: .seconds(1))
                                await MainActor.run {
                                    navigationRouter.pop()
                                }
                            }
                        },
                        onCancel: {
                            isDeleteAlertPresented = false
                        }
                    )
                }
                .zIndex(3)
            }
            
            if viewModel.showStatusToast {
                FeedbackToastView(type: toastType)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(3)
                .padding(.bottom, 44)
            }
            
            if viewModel.loadingManager.isLoadingNetwork {
                LoadingView()
            }
            
            if viewModel.showDeletedProductAlert {
                DeletedProductView(onGoToHomeButtonTapped: {
                    navigationRouter.pop()
                })
                .zIndex(4)
            }

            if shouldPresentPhoneVerificationModal {
                ZStack(alignment: .center) {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()

                    PermissionAlertView(
                        content: .phoneVerification,
                        onDismiss: {
                            phoneVerificationManager.dismissModal()
                        },
                        onPrimaryAction: {
                            phoneVerificationManager.dismissModal()
                            navigationRouter.push(next: .phoneVerificationView)
                        }
                    )
                    .frame(width: 284, height: 290)
                }
                .transition(.opacity)
                .zIndex(5)
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
        .animation(.spring(), value: viewModel.showInterestToast)
        .animation(.spring(), value: viewModel.showCopyToast)
        .animation(.easeInOut(duration: 0.3), value: viewModel.showStatusToast)
        .animation(.easeInOut(duration: 0.3), value: isReportModalPresented)
        .animation(.easeInOut(duration: 0.3), value: isOwnerOptionsModalPresented)
        .fullScreenCover(isPresented: $isRegisterViewPresented) {
            switch viewModel.product.productDetail.tradeType {
            case .sell:
                SellRegisterView(
                    viewModel: RegisterViewModel(viewType: .editProduct(productID: viewModel.product.productDetail.id,
                                                                        tradeType: viewModel.product.productDetail.tradeType)),
                    isRegisterTabSelected: .constant(false),
                    isEditCompleted: $isEditCompleted
                )
            case .buy:
                BuyRegisterView(
                    viewModel: RegisterViewModel(viewType: .editProduct(productID: viewModel.product.productDetail.id,
                                                                        tradeType: viewModel.product.productDetail.tradeType)),
                    isRegisterTabSelected: .constant(false),
                    isEditCompleted: $isEditCompleted
                )
            }
        }
        .fullScreenCover(isPresented: $isImageDetailViewPresented) {
            ImageDetailView(
                isImageDetailViewPresent: $isImageDetailViewPresented,
                imageUrl: viewModel.product.productPhotoList[currentPage].photoUrl
            )
        }
        .onChange(of: isRegisterViewPresented) { value in
            if !value {
                Task {
                    await viewModel.fetchProduct(id: viewModel.product.productDetail.id)
                }
                if isEditCompleted {
                    toastType = .productEdited
                    Task {
                        viewModel.showStatusToast = true
                        try? await Task.sleep(for: .seconds(1.5))
                        viewModel.showStatusToast = false
                    }
                }
            }
        }
        .sheet(isPresented: $isShareSheetPresented) {
            ActivitySheetView(activityItems: [viewModel.universalLink]) { activityType, completed in
                guard completed else { return }
                
                if activityType == .copyToPasteboard {
                    Task {
                        UIPasteboard.general.url = viewModel.universalLink
                        viewModel.showCopyToast = true
                        try? await Task.sleep(for: .seconds(2))
                        await MainActor.run {
                            viewModel.showCopyToast = false
                        }
                    }
                }
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }
}

extension ProductDetailView {
    private var shouldPresentPhoneVerificationModal: Bool {
        guard phoneVerificationManager.isModalPresented,
              case .productDetailChat(let productID) = phoneVerificationManager.currentEntryPoint else {
            return false
        }

        return productID == viewModel.product.productDetail.id
    }

    
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
                    isShareSheetPresented = true
                } label: {
                    Image(.iconShare)
                        .frame(width: 24, height: 24)
                }
                Button {
                    if viewModel.product.productDetail.isOwnedByCurrentUser {
                        isOwnerOptionsModalPresented  = true
                        viewModel.isTooltipPresented = false
                    } else {
                        isReportModalPresented = true
                    }
                } label: {
                    Image(.iconMoreOptions)
                        .frame(width: 24, height: 24)
                }
                .padding(.trailing, 18)
            }
        }
        .frame(height: 94)
        .padding(.bottom, 4)
        .padding(.horizontal, 9)
        .background(
            Color.napzakGrayScale(.white)
                .shadow(color: .black.opacity(0.1), radius: 2)
        )
    }
    
    private var mainScrollView: some View {
        ScrollView {
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
                    Button {
                        isImageDetailViewPresented = true
                    } label: {
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
                .applyNapzakFont(.title4SemiBold20)
                .foregroundStyle(Color.napzakGrayScale(.black))
                .padding(.bottom, 10)
            Text(viewModel.product.productDetail.price.convertPriceByTradeType(tradeType: viewModel.product.productDetail.tradeType))
                .applyNapzakFont(.title1Bold22)
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
            HStack(alignment: .bottom, spacing: 4) {
                Image(.icnChatCountBig)
                    .padding(.bottom, 1)
                Text("\(viewModel.product.productDetail.chatCount)")
                    .applyNapzakFont(.body6Regular14)
                    .foregroundStyle(Color.napzakGrayScale(.gray200))
                    .frame(height: 18)
                Image(.icnHeartCountBig)
                    .padding(.bottom, 2)
                Text("\(viewModel.product.productDetail.interestCount)")
                    .applyNapzakFont(.body6Regular14)
                    .foregroundStyle(Color.napzakGrayScale(.gray200))
                    .frame(height: 18)
            }
        }
        .padding(.bottom, 16)
    }
    
    private var productDescription: some View {
        ZStack(alignment: .top) {
            Color.napzakGrayScale(.white)
            Text("\(viewModel.product.productDetail.description)".forceCharWrapping)
                .applyNapzakFont(.body6Regular14)
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
                        Text("일반택배 \(viewModel.product.productDetail.standardDeliveryFee.convertPriceByTradeType(tradeType: viewModel.product.productDetail.tradeType))")
                            .applyNapzakFont(.body4Bold14)
                            .foregroundStyle(Color.napzakGrayScale(.gray300))
                    }
                    if viewModel.product.productDetail.halfDeliveryFee != 0 {
                        Text("반값/알뜰택배 \(viewModel.product.productDetail.halfDeliveryFee.convertPriceByTradeType(tradeType: viewModel.product.productDetail.tradeType))")
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
            Button {
                navigationRouter.push(next: .marketView(storeId: viewModel.product.storeInfo.id))
            } label: {
                HStack(alignment: .center, spacing: 0) {
                    Group {
                        if let url = URL(string: viewModel.product.storeInfo.storePhoto) {
                            KFImage(url)
                                .placeholder {
                                    Image(.profileImg)
                                }.retry(maxCount: 3, interval: .seconds(3))
                                .onFailure { error  in
                                    print("failure: \(error.localizedDescription)")
                                }
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            Image(.profileImg)
                        }
                    }
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
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
                    Image(.iconArrowRight)
                        .frame(width: 22, height: 30)
                    
                }
                .padding(.vertical, 17)
                .padding(.horizontal, 22)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.napzakGrayScale(.gray10))
                )
            }
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
                    Task {
                        let status = await phoneVerificationManager.resolveVerificationStatusIfNeeded()

                        if status == .verified {
                            navigationRouter.push(
                                next: .chatDetailView(
                                    chatEntry: .product(
                                        id: viewModel.product.productDetail.id
                                    )
                                )
                            )
                        } else if status == .unverified {
                            phoneVerificationManager.presentModal(
                                for: .productDetailChat(productID: viewModel.product.productDetail.id)
                            )
                        }
                    }
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
    
    func statusString(status: TradeStatus) -> String {
        switch status {
        case .beforeTrade:
            return "\(viewModel.product.productDetail.tradeType.type)중"
        case .reserved:
            return "예약중"
        case .completed:
            return "\(viewModel.product.productDetail.tradeType.type)완료"
        }
    }
}
