//
//  NZAlertView.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/11/25.
//

import SwiftUI

enum AlertStyle {
    case plain
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
    
    @State private var isProcessing: Bool = false
    @State private var hasConfirmed: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Text(titleMessage)
                .applyNapzakFont(.title3Bold18)
                .foregroundStyle(style == .plain ? Color.napzakPrimary(.purple500) : Color.napzakState(.red))
                .frame(maxWidth: .infinity)
            
            if let message = subTitleMessage {
                Text(message)
                    .applyNapzakFont(.caption1SemiBold12)
                    .foregroundStyle(Color.napzakGrayScale(.gray200))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 6)
            }
            Spacer()
            
            Color.napzakGrayScale(.gray200)
                .frame(height: 1)
            
            HStack(alignment: .center, spacing: 0) {
                Button {
                    confirmOnce()
                } label: {
                    Text(confirmText)
                        .applyNapzakFont(.body5SemiBold14)
                        .foregroundStyle(Color.napzakGrayScale(.gray300))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .disabled(isProcessing)
                
                Color.napzakGrayScale(.gray200)
                    .frame(width: 1)
                
                Button{
                    if !isProcessing {
                        onCancel()
                    }
                } label: {
                    Text(cancelText)
                        .applyNapzakFont(.body5SemiBold14)
                        .foregroundStyle(Color.napzakGrayScale(.gray300))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .disabled(isProcessing)
                
            }
            .frame(height: 50)
        }
        .frame(height: 150)
        .background(
            RoundedRectangle(cornerRadius: 13)
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
