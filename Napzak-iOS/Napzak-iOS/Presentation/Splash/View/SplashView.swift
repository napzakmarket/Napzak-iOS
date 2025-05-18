//
//  SplashView.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/18/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        GeometryReader { geometry in
            Image(.iosSplash)
                .resizable()
                .ignoresSafeArea()
        }
    }
}

#Preview {
    SplashView()
}
