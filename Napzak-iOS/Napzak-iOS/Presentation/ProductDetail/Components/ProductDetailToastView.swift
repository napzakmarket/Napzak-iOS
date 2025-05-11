//
//  ProductDetailToastView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 5/8/25.
//

import SwiftUI

enum ProductDetailToastStyle {
    case statusChanged
    case deleteProduct
    
    var icon: Image {
        switch self {
        case .statusChanged: return Image(.iconStatusToast)
        case .deleteProduct: return Image(.iconDeleteToast)
        }
    }
    
    func message(_ tradeStatus: String? = nil) -> String {
        switch self {
        case .statusChanged: return "상품 상태를 \"\(tradeStatus ?? "")\"으로 변경하였습니다."
        case .deleteProduct: return "상품이 삭제되었습니다."
        }

    }
}

struct ProductDetailToastView: View {
    
    //MARK: - Properties

    let style: ProductDetailToastStyle
    let tradeStatus: String?
    
    //MARK: - Body
    
    var body: some View {
        HStack(spacing: 6) {
            style.icon
            Text(style.message(tradeStatus))
                .applyNapzakFont(.body5SemiBold14)
                .foregroundStyle(Color.napzakGrayScale(.white))
                .frame(height: 18)
        }
        .padding(.vertical, 13)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.napzakTransparency(.transBlack))
        )
        .padding(.horizontal, 37)
    }
}

#Preview {
    ProductDetailToastView(style: .statusChanged, tradeStatus: "판매중")
}
