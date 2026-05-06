//
//  OnboardingNavigationBar.swift
//  Napzak-iOS
//
//  Created by 조호근 on 3/26/25.
//

import SwiftUI

struct OnboardingNavigationBar: View {
    let step: Int
    let onBack: () -> Void
    
    private let totalSteps = 4
    
    var body: some View {
        HStack {
            Button {
                onBack()
                print("뒤로가기 눌림")
            } label: {
                Image(.iconBack)
                    .frame(width: 44, height: 44)
            }
            .padding(.leading, 3)
            
            Spacer()
            
            HStack(spacing: 4) {
                ForEach(1...totalSteps, id: \.self) { index in
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
            .animation(.easeInOut(duration: 0.4), value: step)
        }
    }
}

#Preview {
    OnboardingNavigationBar(step: 2, onBack: {})
}
