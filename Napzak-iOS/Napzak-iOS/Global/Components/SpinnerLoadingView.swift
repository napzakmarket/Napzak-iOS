//
//  SpinnerLoadingView.swift
//  Napzak-iOS
//
//  Created by OneTen on 7/5/25.
//

import SwiftUI

import Lottie

struct SpinnerLoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                LottieView(animation: .named("spinner"))
                    .configure({ lottieAnimationView in
                        lottieAnimationView.contentMode = .scaleAspectFill
                        lottieAnimationView.shouldRasterizeWhenIdle = false
                    })
                    .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 58, height: 73)
                
                Spacer()
            }
            Spacer()
        }
        .background(Color.napzakGrayScale(.gray10))
    }
}

#Preview {
    SpinnerLoadingView()
}
