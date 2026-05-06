//
//  VerificationSectionView.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/25/26.
//

import SwiftUI

struct VerificationSectionView: View {
    @Binding var code: String

    let timerText: String
    let isVerified: Bool
    let isCodeInputEnabled: Bool
    let buttonState: VerifyButtonState

    let onTapVerify: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            titleText
            codeField
            verifyButton
        }
    }
}

extension VerificationSectionView {
    private var titleText: some View {
        Text("인증 번호")
            .applyNapzakFont(.caption3Regular12)
            .foregroundStyle(Color.napzakGrayScale(.gray300))
    }

    private var codeField: some View {
        ZStack {
            Rectangle()
                .fill(Color.clear)
                .frame(width: 1, height: 30)

            HStack(spacing: 6) {
                if isVerified {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.green)
                }

                TextField(
                    "",
                    text: $code,
                    prompt: Text("6자리 숫자를 입력해주세요")
                        .font(.napzakFont(.caption1SemiBold12))
                        .foregroundColor(Color.napzakGrayScale(.gray200))
                )
                .applyNapzakFont(.caption1SemiBold12, lineSpacingEnabled: false)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .tint(Color.napzakGrayScale(.gray500))
                .keyboardType(.numberPad)
                .disabled(isCodeInputEnabled == false)

                Spacer()

                Text(timerText)
                    .applyNapzakFont(.caption1SemiBold12)
                    .foregroundStyle(timerTextColor)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.napzakGrayScale(.gray50))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var verifyButton: some View {
        Button {
            onTapVerify()
        } label: {
            Text(buttonTitle)
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(buttonTextColor)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(buttonBackgroundColor)
                .overlay {
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(buttonBorderColor, lineWidth: 1)
                }
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .disabled(buttonState != .enabled)
    }

    private var buttonTitle: String {
        switch buttonState {
        case .disabled, .enabled:
            return "인증번호 확인하기"
        case .completed:
            return "인증 완료"
        }
    }

    private var timerTextColor: Color {
        isVerified
        ? Color.napzakGrayScale(.gray300)
        : Color.napzakPrimary(.purple500)
    }

    private var buttonTextColor: Color {
        switch buttonState {
        case .disabled:
            return .white

        case .enabled:
            return Color.napzakPrimary(.purple500)

        case .completed:
            return Color.napzakGrayScale(.gray100)
        }
    }

    private var buttonBorderColor: Color {
        switch buttonState {
        case .disabled:
            return Color.napzakGrayScale(.gray100)

        case .enabled:
            return Color.napzakPrimary(.purple500)

        case .completed:
            return Color.napzakGrayScale(.gray100)
        }
    }

    private var buttonBackgroundColor: Color {
        switch buttonState {
        case .disabled:
            return Color.napzakGrayScale(.gray100)

        case .enabled, .completed:
            return .white
        }
    }
}

#Preview("인증번호 미입력") {
    VerificationSectionView(
        code: .constant(""),
        timerText: "02:59",
        isVerified: false,
        isCodeInputEnabled: true,
        buttonState: .disabled,
        onTapVerify: {}
    )
    .padding(20)
}

#Preview("6자리 입력 완료") {
    VerificationSectionView(
        code: .constant("123456"),
        timerText: "00:21",
        isVerified: false,
        isCodeInputEnabled: true,
        buttonState: .enabled,
        onTapVerify: {}
    )
    .padding(20)
}

#Preview("인증 완료") {
    VerificationSectionView(
        code: .constant("123456"),
        timerText: "00:00",
        isVerified: true,
        isCodeInputEnabled: false,
        buttonState: .completed,
        onTapVerify: {}
    )
    .padding(20)
}
