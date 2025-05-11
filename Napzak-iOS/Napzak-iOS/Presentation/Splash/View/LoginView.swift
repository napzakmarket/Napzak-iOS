//
//  LoginView.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/1/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var authRouter: AuthNavigationRouter
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack(path: $authRouter.path) {
            VStack(spacing: 10) {
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
    LoginView()
}
