//
//  PermissionModalView.swift
//  Napzak-iOS
//
//  Created by 조호근 on 7/14/25.
//

import SwiftUI

struct PermissionAlertView: View {
    enum Content: Equatable {
        case push(PushOffState)
        case phoneVerification

        var icon: ImageResource {
            switch self {
            case .push:
                return .iconNotification
            case .phoneVerification:
                return .iconVerify
            }
        }

        var title: String {
            switch self {
            case .push(let state):
                return state.message
            case .phoneVerification:
                return "본인 확인이 필요해요"
            }
        }

        var subtitle: String {
            switch self {
            case .push:
                return "실시간 거래 알림을 받으려면\n설정을 변경해주세요."
            case .phoneVerification:
                return "안전한 거래를 위해 휴대폰 인증 후\n서비스를 이용할 수 있어요"
            }
        }

        var buttonTitle: String {
            switch self {
            case .push:
                return "알림 켜기"
            case .phoneVerification:
                return "인증하기"
            }
        }
    }

    let content: Content
    var onDismiss: (() -> Void)? = nil
    let onPrimaryAction: () -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack(alignment: .top) {
                HStack {
                    Spacer()

                    Button {
                        onDismiss?()
                    } label: {
                        Image(.iconClose)
                    }
                }
                .padding([.top, .trailing], 10)

                Image(content.icon)
                    .padding(.top, 31)
            }

            Text(content.title)
                .applyNapzakFont(.body1Bold16)
                .padding(.top, 17)

            Text(content.subtitle)
                .lineLimit(2)
                .applyNapzakFont(.caption1SemiBold12, lineSpacingEnabled: false)
                .foregroundStyle(Color.napzakGrayScale(.gray200))
                .multilineTextAlignment(.center)
                .padding(.top, 10)
                .frame(height: 40)

            Button {
                onPrimaryAction()
            } label: {
                Text(content.buttonTitle)
                    .applyNapzakFont(.body5SemiBold14)
                    .foregroundStyle(Color.napzakGrayScale(.white))
                    .frame(width: 232, height: 37)
                    .background(Color.napzakPrimary(.purple500))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.top, 15)
            .padding(.bottom, 24)
        }
        .background(Color.white)
        .cornerRadius(12)
    }
}

private struct PermissionAlertPreviewWrapper: View {
    let content: PermissionAlertView.Content

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()

            PermissionAlertView(
                content: content,
                onPrimaryAction: {}
            )
            .frame(width: 284, height: 290)
        }
    }
}

#Preview("Push App Off") {
    PermissionAlertPreviewWrapper(content: .push(.appOnlyOff))
}

#Preview("Push OS Off") {
    PermissionAlertPreviewWrapper(content: .push(.osOnlyOff))
}

#Preview("Push Both Off") {
    PermissionAlertPreviewWrapper(content: .push(.bothOff))
}

#Preview("Phone Verification") {
    PermissionAlertPreviewWrapper(content: .phoneVerification)
}
