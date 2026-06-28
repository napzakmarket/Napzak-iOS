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
        case share
        
        var icon: Image? {
            switch self {
            case .warning: return Image(.toastWarning)
            default: return nil
            }
        }
        
        var textColor: Color? {
            switch self {
            case .warning: return Color.napzakState(.red)
            default: return nil
            }
        }
        
        var backgroundColor: Color? {
            switch self {
            case .warning: return
                Color.napzakTransparency(.transWhite, opacity: 0.5)
            default: return nil
            }
        }
        
        var borderColor: Color? {
            switch self {
            case .warning: return Color.napzakState(.red)
            default: return nil
           }
        }
    }

    var message: String = ""
    let style: Style

    var body: some View {
        switch style {
        case .warning:
            HStack(spacing: 6) {
                style.icon
                Text(message)
                    .applyNapzakFont(.caption1SemiBold12)
                    .foregroundStyle(style.textColor ?? Color.clear)
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
            
        case .success:
            Image(.toastLike)
        case .share:
            Image(.imgToastShare)
        }
        
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
        style: .success
    )
}

#Preview("share") {
    ToastMessageView(
        style: .share
    )
}
