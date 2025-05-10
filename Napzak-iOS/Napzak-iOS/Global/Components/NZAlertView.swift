//
//  NZAlertView.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/11/25.
//

import SwiftUI

struct NZAlertView: View {
    let message: String
    let confirmText: String
    let cancelText: String
    let onConfirm: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Text(message)
                .applyNapzakFont(.title3Bold18)
                .foregroundStyle(Color.napzakPrimary(.purple500))
                .frame(height: 23)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 38)
            
            Color.napzakGrayScale(.gray200)
                .frame(height: 1)
            
            HStack(alignment: .center, spacing: 0) {
                Button(action: onConfirm) {
                    Text(confirmText)
                        .applyNapzakFont(.body5SemiBold14)
                        .foregroundStyle(Color.napzakGrayScale(.gray300))
                        .frame(maxWidth: .infinity)
                }
                .frame(height: 50)
                
                Color.napzakGrayScale(.gray200)
                    .frame(width: 1)
                
                Button(action: onCancel) {
                    Text(cancelText)
                        .applyNapzakFont(.body5SemiBold14)
                        .foregroundStyle(Color.napzakGrayScale(.gray300))
                        .frame(maxWidth: .infinity)
                }
                .frame(height: 50)
            }
        }
        .background(Color.white)
        .frame(height: 150)
        .clipShape(RoundedRectangle(cornerRadius: 13))
    }
}

#Preview {
    NZAlertView(
        message: "로그아웃 하시겠어요?",
        confirmText: "예",
        cancelText: "아니요",
        onConfirm: {
        },
        onCancel: {
        }
    )
}
