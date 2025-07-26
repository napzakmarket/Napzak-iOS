//
//  LoadingView.swift
//  Napzak-iOS
//
//  Created by OneTen on 6/18/25.
//

import SwiftUI

import Lottie

struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                LottieView(animation: .named("ios_loading"))
                    .configure { lottieAnimationView in
                        lottieAnimationView.contentMode = .scaleAspectFill
                        lottieAnimationView.shouldRasterizeWhenIdle = false
                    }
                    .playbackMode(.playing(.toProgress(0.85, loopMode: .loop)))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 58, height: 73)
                
                Spacer()
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
    }
}

#Preview {
    LoadingView()
}
