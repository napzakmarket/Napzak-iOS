//
//  LoginView.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/1/25.
//

import SwiftUI

import Lottie

struct LoginView: View {
    @EnvironmentObject private var authRouter: AuthNavigationRouter
    @StateObject private var viewModel = LoginViewModel()
    @State private var showButton: Bool = false
    
    var body: some View {
        NavigationStack(path: $authRouter.path) {
            ZStack {
                LottieView(animation: .named("ios"))
                    .configure({ lottieAnimationView in
                        lottieAnimationView.contentMode = .scaleAspectFill
                        lottieAnimationView.shouldRasterizeWhenIdle = false
                    })
                    .playbackMode(.playing(.toProgress(1, loopMode: .playOnce)))
                    .animationDidFinish { _ in
                        withAnimation(.easeIn(duration: 0.3)) {
                            showButton = true
                        }
                    }
                    .ignoresSafeArea(.all)
                
                if showButton {
                    VStack {
                        Spacer()
                        
                        VStack(spacing: 15) {
                            Button {
                                Task {
                                    await viewModel.handleKakaoLogin(router: authRouter)
                                }
                            } label: {
                                Image(.buttonLoginKakao)
                            }
                            .disabled(viewModel.isLoading)
                            
                            Button {
                                Task {
                                    await viewModel.handleAppleAuthCode(router: authRouter)
                                }
                            } label: {
                                Image(.buttonLoginApple)
                            }
                        }
                    }
                    .padding(.bottom, 77)
                }
            }
            .navigationDestination(for: OnboardingStep.self) { step in
                switch step {
                case .terms:
                    OnboardingTermsView()
                case .username:
                    UsernameInputView()
                case .genre:
                    GenreSelectionView()
                case .completed:
                    Color.clear
                        .onAppear {
                            OnboardingManager.shared.saveCheckpoint(.completed)
                            AuthManager.shared.completeOnboarding()
                            authRouter.reset()
                        }
                }
            }
        }
    }
}

#Preview {
    struct PreviewContainer: View {
        @StateObject var authRouter = AuthNavigationRouter()
        
        var body: some View {
            LoginView()
                .environmentObject(authRouter)
        }
    }
    
    return PreviewContainer()
}
