//
//  ProductItemView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/16/25.
//

import SwiftUI

import Kingfisher

struct ProductItemView: View {
    
    @Binding var product: ProductItemModel
    
    //MARK: - Properties
    
    let width: CGFloat
    let isHiddenProductSummary: Bool
    let shouldToggleInterestState: () -> Void
    
    //MARK: - Main Body
    
    var body: some View {
        VStack {
            productMain
            productInfo
        }
    }
}

extension ProductItemView {
    
    //MARK: - UI Properties
    
    private var productMain: some View {
        ZStack(alignment: .bottom) {
            productImage
            if product.tradeStatus != .beforeTrade {
                tradeStatusOverlay
            }
            productTypeInterest
        }
        .frame(width: width, height: width * 1.05)
        .contentShape(Rectangle())
        .clipShape(RoundedRectangle(cornerRadius: 3))
    }
    
    private var productInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(product.genreName)
                    .applyNapzakFont(.caption3Regular12)
                    .foregroundStyle(Color.napzakGrayScale(.gray500))
                    .frame(height: 15)
                Spacer()
            }
            Text(product.productName)
                .applyNapzakFont(.body5SemiBold14)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .frame(height: 18)
                .lineLimit(1)
            Text(product.price.convertPriceByTradeType(tradeType: product.tradeType))
                .applyNapzakFont(.body1Bold16)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .frame(height: 20)
                .lineLimit(1)
                .padding(.top, 4)
            if !isHiddenProductSummary {
                productSummary
            }
        }
        .frame(width: width)
    }
    
    private var productImage: some View {
        Group {
            if let imageURL = product.photo, let url = URL(string: imageURL) {
                KFImage(url)
                    .placeholder {
                        Rectangle()
                            .fill(Color.napzakGrayScale(.gray100))
                    }
                    .retry(maxCount: 3, interval: .seconds(5))
                    .onFailure { error in
                        print("failure: \(error.localizedDescription)")
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Rectangle()
                    .fill(Color.napzakGrayScale(.gray100))
            }
        }
        .frame(width: width, height: width * 1.05)
    }
    
    private var tradeStatusOverlay: some View {
        ZStack {
            Color.napzakTransparency(.transBlack)
            VStack(spacing: 6) {
                if product.tradeStatus == .completed {
                    Image(product.tradeType == .sell ? .imgTradeSellSm : .imgTradeBuySm)
                    Text(product.tradeType == .sell ? "판매 완료" : "구매 완료")
                        .applyNapzakFont(.body4Bold14)
                        .foregroundStyle(Color.napzakGrayScale(.white))
                } else if product.tradeStatus == .reserved {
                    Image(.imgTradeReservedSm)
                    Text("예약중")
                        .applyNapzakFont(.body4Bold14)
                        .foregroundStyle(Color.napzakGrayScale(.white))
                }
            }
        }
    }
    
    private var productTypeInterest: some View {
        HStack(alignment: .bottom, spacing: 0) {
            HStack(alignment: .bottom, spacing: 2) {
                switch product.tradeType {
                case .sell:
                    Image(.imgChipSell)
                case .buy:
                    Image(.imgChipBuy)
                }
                if let isPriceNegotiable = product.isPriceNegotiable {
                    if isPriceNegotiable {
                        Image(.imgChipBidding)
                    }
                }
            }
            Spacer(minLength: 5)
            if !product.isOwnedByCurrentUser {
                likeButton
            }
        }
    }
    
    private var likeButton: some View {
        Button {
            Task {
                shouldToggleInterestState()
            }
        } label: {
            Image(product.isInterested ? .btnHeartSelected : .btnHeartDefault)
                .resizable()
                .scaledToFit()
                .frame(width: isHiddenProductSummary ? 14 : 16, height: isHiddenProductSummary ? 13 : 15)
        }
        .padding(.bottom, isHiddenProductSummary ? 6 : 9)
        .padding(.trailing, isHiddenProductSummary ? 5 :9)
    }
    
    private var productSummary: some View {
        HStack(alignment: .bottom, spacing: 2) {
            Text(product.uploadTime)
                .applyNapzakFont(.caption3Regular12)
                .foregroundStyle(Color.napzakGrayScale(.gray200))
                .frame(height: 15)
            Spacer()
            Image(.icnChatCount)
            Text("\(product.chatCount)")
                .applyNapzakFont(.caption5Regular10)
                .foregroundStyle(Color.napzakGrayScale(.gray200))
                .frame(height: 13)
            Image(.icnHeartCount)
                .padding([.leading, .bottom], 1)
            Text("\(product.interestCount)")
                .applyNapzakFont(.caption5Regular10)
                .foregroundStyle(Color.napzakGrayScale(.gray200))
                .frame(height: 13)
        }
    }
}

#Preview {
    struct PreviewContainer: View {
        @State var product = ProductItemModel.dummyProducts[1]

        var body: some View {
            ProductItemView(product: $product, width: 116,
                            isHiddenProductSummary: true,
                            shouldToggleInterestState: {})
        }
    }
    
    return PreviewContainer()
}
