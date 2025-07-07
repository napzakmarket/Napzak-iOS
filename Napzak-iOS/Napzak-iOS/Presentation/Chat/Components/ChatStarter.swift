//
//  ChatStarter.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 6/30/25.
//

import SwiftUI

struct ChatStarter: View {
    
    //MARK: - Properties
    
    let product: ProductMeta
    let isMessageOwner: Bool
    let onProductButtonTapped: () -> Void
    
    //MARK: - Main Body
    
    var body: some View {
        VStack(spacing: 0) {
            header
            VStack(spacing: 0) {
                productSummary
                productButton
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            .background(
                Color.napzakGrayScale(.gray50)
            )
        }
        .clipShape(RoundedCornerShape(
            topLeft: 12,
            topRight: 12,
            bottomLeft: isMessageOwner ? 12 : 0,
            bottomRight: isMessageOwner ? 0 : 12
        ))
    }
}

extension ChatStarter {
    
    //MARK: - UI Properties
    
    private var header: some View {
        Text("\(product.tradeType.title) 상품 문의\(isMessageOwner ? "를 전송했어요!" : "가 도착했어요!")")
            .applyNapzakFont(.caption1SemiBold12)
            .foregroundStyle(Color.napzakGrayScale(.white))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 11)
            .background(
                Color.napzakPrimary(.purple500)
            )
    }
    
    private var productSummary: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(product.genreName)
                    .applyNapzakFont(.caption4SemiBold10)
                    .foregroundStyle(Color.napzakGrayScale(.black))
                Spacer()
            }
            Text(product.title)
                .applyNapzakFont(.caption1SemiBold12)
                .foregroundStyle(Color.napzakGrayScale(.black))
            Text(product.price.convertPriceByTradeType(tradeType: product.tradeType))
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(Color.napzakGrayScale(.black))
        }
        .padding(.vertical, 15)
    }
    
    private var productButton: some View {
        Button {
            
        } label: {
            Text("상품 보러 가기")
                .applyNapzakFont(.caption4SemiBold10)
                .foregroundStyle(Color.napzakGrayScale(.white))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 9)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.napzakGrayScale(.gray500))
                )
        }
    }
}

#Preview {
    struct PreviewContainer: View {
        let product = ProductMeta(
            type: .product,
            tradeType: .sell,
            productId: 0,
            genreName: "은혼",
            title: "은혼 긴토키 히지카타 룩업",
            price: 123000
        )
        
        var body: some View {
            ChatStarter(
                product: product,
                isMessageOwner: false,
                onProductButtonTapped: { }
            )
        }
    }
    
    return PreviewContainer()
        .frame(width: 233)
}
