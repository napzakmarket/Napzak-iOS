//
//  NZAlertView.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/11/25.
//

import SwiftUI

enum AlertStyle {
    case plain
    case primary
    case warning
}

struct NZAlertView: View {
    let style: AlertStyle
    let titleMessage: String
    var subTitleMessage: String? = nil
    let confirmText: String
    let cancelText: String
    let onConfirm: () async -> Void
    let onCancel: () -> Void
    
    var titleColor: Color {
        switch style {
        case .plain:
            return Color.napzakGrayScale(.black)
        case .primary:
            return Color.napzakPrimary(.purple500)
        case .warning:
            return Color.napzakState(.red)
        }
    }
    
    @State private var isProcessing: Bool = false
    @State private var hasConfirmed: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Text(titleMessage)
                .applyNapzakFont(.body1Bold16)
                .foregroundStyle(titleColor)
                .frame(height: 20)
                .frame(maxWidth: .infinity)
                .padding(.top, 11)
            
            if let message = subTitleMessage {
                Text(message)
                    .applyNapzakFont(.caption1SemiBold12)
                    .foregroundStyle(Color.napzakGrayScale(.gray200))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 6)
            }
            Spacer()
            
            HStack(alignment: .center, spacing: 10) {
                Button {
                    confirmOnce()
                } label: {
                    Text(confirmText)
                        .applyNapzakFont(.body5SemiBold14)
                        .foregroundStyle(Color.napzakGrayScale(.white))
                        .frame(height: 37)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.napzakPrimary(.purple500))
                        )
                }
                .disabled(isProcessing)
                
                Button{
                    if !isProcessing {
                        onCancel()
                    }
                } label: {
                    Text(cancelText)
                        .applyNapzakFont(.body5SemiBold14)
                        .foregroundStyle(Color.napzakGrayScale(.gray400))
                        .frame(height: 37)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.napzakGrayScale(.gray50))
                        )
                }
                .disabled(isProcessing)
            }
            .padding(.bottom, 24)
        }
        .padding(.horizontal, 26)
        .frame(height: 162)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
        )
        .padding(.horizontal, 45)
    }
    
    private func confirmOnce() {
        guard !isProcessing && !hasConfirmed else { return }
        isProcessing = true
        hasConfirmed = true

        Task {
            await onConfirm()
            isProcessing = false
        }
    }
}

#Preview {
    struct PreviewContainer: View {
        var body: some View {
            ZStack {
                Color.napzakTransparency(.transBlack)
                    .zIndex(1)
                
                NZAlertView(
                    style: .primary,
                    titleMessage: "채팅방 나가기",
                    subTitleMessage: "채팅방에서 나가시겠어요? 나가기를 하면\n더이상 상대방과 대화할 수 없습니다.",
                    confirmText: "예",
                    cancelText: "아니요",
                    onConfirm: { },
                    onCancel: { }
                )
                .zIndex(2)
            }
        }
    }
    
    return PreviewContainer()
}
