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
    @EnvironmentObject private var phoneVerificationManager: PhoneVerificationManager
    @StateObject private var viewModel = LoginViewModel()
    @ObservedObject private var authManager = AuthManager.shared
    @State private var showButton: Bool = false
    @State private var hasResumedOnboarding = false
    
    var body: some View {
        NavigationStack(path: $authRouter.path) {
            ZStack {
                LottieView(animation: .named("ios"))
                    .configure({ lottieAnimationView in
                        lottieAnimationView.contentMode = .scaleAspectFill
                        lottieAnimationView.shouldRasterizeWhenIdle = false
                    })
                    .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea(.all)
                    .task {
                        try? await Task.sleep(for: .seconds(2))
                        withAnimation(.easeIn(duration: 0.3)) {
                            showButton = true
                        }
                    }
                
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
                case .phoneVerification:
                    OnboardingPhoneVerificationRouteView()
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
            .appAlert(
                isPresented:  $viewModel.showAlert,
                style: .banned,
                onConfirm: {
                    viewModel.showAlert = false
                }
            )
            .task {
                await resumeOnboardingIfNeeded()
            }
            .onChange(of: authManager.isAuthenticated) { isAuthenticated in
                if isAuthenticated {
                    Task {
                        await resumeOnboardingIfNeeded()
                    }
                } else {
                    hasResumedOnboarding = false
                }
            }
        }
    }
}

extension LoginView {
    @MainActor
    private func resumeOnboardingIfNeeded() async {
        guard authManager.isAuthenticated,
              authManager.needsOnboarding,
              authRouter.path.isEmpty,
              hasResumedOnboarding == false else {
            return
        }

        hasResumedOnboarding = true

        let checkpoint = OnboardingManager.shared.getLastCheckpoint() ?? .terms
        authRouter.replacePath(with: checkpoint.restorationPath)
    }
}

private struct OnboardingPhoneVerificationRouteView: View {
    @EnvironmentObject private var authRouter: AuthNavigationRouter

    var body: some View {
        PhoneVerificationView(
            navigationStyle: .onboarding(step: 2),
            onBack: {
                authRouter.pop()
            },
            onNext: {
                OnboardingManager.shared.saveCheckpoint(.username)
                authRouter.push(next: .username)
            }
        )
    }
}

#Preview {
    struct PreviewContainer: View {
        @StateObject var authRouter = AuthNavigationRouter()
        @StateObject var phoneVerificationManager = PhoneVerificationManager()
        
        var body: some View {
            LoginView()
                .environmentObject(authRouter)
                .environmentObject(phoneVerificationManager)
        }
    }
    
    return PreviewContainer()
}
