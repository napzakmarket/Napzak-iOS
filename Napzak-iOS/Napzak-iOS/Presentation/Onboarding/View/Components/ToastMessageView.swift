//
//  ToastMessageView.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/7/25.
//

import SwiftUI

struct ToastMessageView: View {
    let message: String
    
    var body: some View {
        HStack(spacing: 3) {
            Image(.toastWarning)
            
            Text(message)
                .applyNapzakFont(.caption1SemiBold12)
                .foregroundStyle(Color.napzakState(.red))
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 7)
        .background(Color.white)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.napzakState(.red), lineWidth: 1)
        )
        .frame(height: 29)
    }
}

#Preview {
    ToastMessageView(message: "관심 장르는 최대 7개까지만 고를 수 있어요")
}
