//
//  UsernameInputView.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/1/25.
//

import SwiftUI

struct UsernameInputView: View {
    @EnvironmentObject private var authRouter: AuthNavigationRouter
    @StateObject private var viewModel = UsernameInputViewModel()
    @FocusState private var isKeyboardActive: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            OnboardingNavigationBar(step: 2) {
                authRouter.pop()
            }
            
            VStack(alignment: .leading ,spacing: 0) {
                Text("납작마켓에서 사용할\n이름을 알려주세요")
                    .lineLimit(2)
                    .applyNapzakFont(.title2Bold20)
                    .foregroundStyle(Color.napzakGrayScale(.gray400))
                    .padding(.top, 20)
                
                Text("띄어쓰기 없이 한글, 영문, 숫자만 사용할 수 있어요 (2~20자)")
                    .applyNapzakFont(.caption3Regular12)
                    .foregroundStyle(Color.napzakGrayScale(.gray300))
                    .padding(.top, 10)
                
                UsernameInputField(
                    validationState: $viewModel.validationState,
                    username: $viewModel.username,
                    isPrimaryButtonEnabled: $viewModel.isPrimaryButtonEnabled
                ) { validatedUsername in
                    Task {
                        await viewModel.validateUsername(validatedUsername)
                    }
                }
                .focused($isKeyboardActive)
                .padding(.top, 30)
                
                Spacer()
                
                PrimaryButton(
                    title: "다음으로",
                    isEnabled: viewModel.isPrimaryButtonEnabled
                ) {
                    Task {
                        if await viewModel.registerUsername() {
                            authRouter.push(next: .genre)
                            print("다음으로")
                        }
                    }
                }
                .padding(.bottom, 75)
            }
            .padding(.horizontal, 20)
        }
        .toolbar(.hidden, for: .navigationBar)
        .contentShape(Rectangle())
        .onTapGesture {
            isKeyboardActive = false
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    UsernameInputView()
}
