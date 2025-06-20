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
                    .configure({ lottieAnimationView in
                        lottieAnimationView.contentMode = .scaleAspectFill
                        lottieAnimationView.shouldRasterizeWhenIdle = false
                    })
                    .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 121, height: 153)
                    .background(.blue)
                
                Spacer()
            }
            Spacer()
        }
        .background(Color.red.opacity(0.4))
    }
}

#Preview {
    LoadingView()
}
