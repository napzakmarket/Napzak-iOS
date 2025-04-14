//
//  OnboardingNavigationBar.swift
//  Napzak-iOS
//
//  Created by 조호근 on 3/26/25.
//

import SwiftUI

struct OnboardingNavigationBar: View {
    let step: Int
    
    var body: some View {
        HStack {
            Button {
                // TODO: Destination 뒤로가기 동작 구현
                
                print("뒤로가기 눌림")
            } label: {
                Image(.iconBack)
                    .frame(width: 44, height: 44)
            }
            .padding(.leading, 3)
            
            Spacer()
            
            Image("indicator\(String(format: "%02d", step))")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 6)
                .padding(.trailing, 20)
        }
    }
}

#Preview {
    OnboardingNavigationBar(step: 1)
}
