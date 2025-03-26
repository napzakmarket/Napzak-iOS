//
//  PrimaryButton.swift
//  Napzak-iOS
//
//  Created by 조호근 on 3/27/25.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 5) {
                Text(title)
                    .applyNapzakFont(.body4Bold14)
                    .foregroundStyle(Color.napzakGrayScale(.white))
                Image(.iconNext)
            }
            .frame(maxWidth: .infinity, minHeight: 50)
        }
        .background(isEnabled ? Color.napzakPrimary(.purple500) : Color.napzakGrayScale(.gray100))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    PrimaryButton(title: "다음으로", isEnabled: false, action: {print("다음으로")})
}
