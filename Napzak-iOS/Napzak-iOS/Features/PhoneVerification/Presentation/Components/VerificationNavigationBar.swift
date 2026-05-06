//
//  VerificationNavigationBar.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/25/26.
//

import SwiftUI

struct VerificationNavigationBar: View {
    let style: VerificationNavigationStyle
    let onBack: () -> Void
    
    var body: some View {
        HStack {
            Button {
                onBack()
            } label: {
                Image(.iconBack)
                    .frame(width: 44, height: 44)
            }
            .padding(.leading, 3)
            
            Spacer()
            
            switch style {
            case .onboarding(let step):
                HStack(spacing: 4) {
                    ForEach(1...4, id: \.self) { index in
                        Circle()
                            .fill(
                                index == step
                                ? Color.napzakPrimary(.purple500)
                                : Color.napzakGrayScale(.gray100)
                            )
                            .frame(width: 6, height: 6)
                    }
                }
                .padding(.trailing, 20)
                
            case .basic:
                Color.clear
                    .frame(width: 24, height: 6)
                    .padding(.trailing, 20)
            }
        }
    }
}

#Preview {
    VerificationNavigationBar(style: .basic, onBack: {})
}
