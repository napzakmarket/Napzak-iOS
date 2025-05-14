//
//  ToastMessageView.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/7/25.
//

import SwiftUI

struct ToastMessageView: View {
    enum Style {
        case warning
        case success
        
        var icon: Image {
            switch self {
            case .warning: return Image(.toastWarning)
            case .success: return Image(.iconHeart)
            }
        }
        
        var textColor: Color {
            switch self {
            case .warning: return Color.napzakState(.red)
            case .success: return .white
            }
        }
        
        var backgroundColor: Color {
            switch self {
            case .warning: return
                Color.napzakTransparency(.transWhite, opacity: 0.5)
            case .success: return Color.napzakPrimary(.purple500)
            }
        }
        
        var borderColor: Color? {
            switch self {
            case .warning: return Color.napzakState(.red)
            case .success: return nil
            }
        }
    }

    let message: String
    let style: Style

    var body: some View {
        HStack(spacing: 6) {
            style.icon
            Text(message)
                .applyNapzakFont(.caption1SemiBold12)
                .foregroundStyle(style.textColor)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 7)
        .background(style.backgroundColor)
        .clipShape(Capsule())
        .overlay(
            Group {
                if let border = style.borderColor {
                    Capsule().stroke(border, lineWidth: 1)
                }
            }
        )
        .frame(height: 29)
    }
}

#Preview("warning") {
    ToastMessageView(
        message: "관심 장르는 최대 7개까지만 고를 수 있어요",
        style: .warning
    )
}

#Preview("success") {
    ToastMessageView(
        message: "찜한 상품에 추가되었어요!",
        style: .success
    )
}
