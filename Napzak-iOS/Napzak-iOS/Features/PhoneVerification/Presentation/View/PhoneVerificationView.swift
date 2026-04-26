//
//  PhoneVerificationView.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/25/26.
//

import SwiftUI

struct PhoneVerificationView: View {
    @StateObject private var viewModel = PhoneVerificationViewModel()
    
    private let navigationStyle: VerificationNavigationStyle
    
    init(navigationStyle: VerificationNavigationStyle = .basic) {
        self.navigationStyle = navigationStyle
    }

    var body: some View {
        VStack(spacing: 0) {
            VerificationNavigationBar(style: navigationStyle, onBack: {})

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VerificationHeaderView()

                    PhoneInputSectionView(
                        name: Binding(
                            get: { viewModel.state.session.name },
                            set: { viewModel.updateName($0) }
                        ),
                        phoneNumber: Binding(
                            get: { viewModel.state.session.phoneNumber },
                            set: { viewModel.updatePhoneNumber($0) }
                        ),
                        isSendButtonEnabled: viewModel.state.isSendButtonEnabled,
                        isSendingCode: viewModel.state.isSendingCode,
                        hasSentCode: viewModel.state.session.isCodeSent,
                        onTapSendCode: {
                            Task {
                                await viewModel.requestCode()
                            }
                        }
                    )

                    VerificationSectionView(
                        code: Binding(
                            get: { viewModel.state.session.verificationCode },
                            set: { viewModel.updateVerificationCode($0) }
                        ),
                        timerText: viewModel.state.timerText,
                        isVerified: viewModel.state.session.isVerified,
                        buttonState: viewModel.state.verifyButtonState,
                        onTapVerify: {
                            Task {
                                await viewModel.verifyCode()
                            }
                        }
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }

            VerificationBottomActionView(
                isChecked: Binding(
                    get: { viewModel.state.session.isAgeConfirmed },
                    set: { _ in viewModel.toggleAgeConfirmation() }
                ),
                isNextEnabled: viewModel.state.isNextEnabled,
                onTapNext: {}
            )
        }
    }
}

#Preview {
    PhoneVerificationView()
}
