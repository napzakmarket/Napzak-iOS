//
//  SplashView.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/18/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.napzakPrimary(.purple500)
                .ignoresSafeArea()
            
            Image(.splashLogo)
                .padding(.horizontal, 40)
                .offset(y: -40)
        }
    }
}

#Preview {
    SplashView()
}
