//
//  PhoneInputSectionView.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/25/26.
//

import SwiftUI

struct PhoneInputSectionView: View {
    @Binding var name: String
    @Binding var phoneNumber: String
    @State private var phoneNumberText: String = ""
    
    let isSendButtonEnabled: Bool
    let isResendEnabled: Bool
    let isSendingCode: Bool
    let hasSentCode: Bool
    
    let onTapSendCode: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            nameField
            phoneField
        }
        .onAppear {
            phoneNumberText = phoneNumber.formattedPhoneNumber
        }
        .onChange(of: phoneNumber) { newValue in
            let formattedValue = newValue.formattedPhoneNumber
            if phoneNumberText != formattedValue {
                phoneNumberText = formattedValue
            }
        }
    }
}

extension PhoneInputSectionView {
    private var nameField: some View {
        ZStack {
            Rectangle()
                .fill(Color.clear)
                .frame(width: 1, height: 30)

            HStack(spacing: 0) {
                TextField(
                    "",
                    text: $name,
                    prompt: Text("이름")
                        .font(.napzakFont(.caption1SemiBold12))
                        .foregroundColor(Color.napzakGrayScale(.gray200))
                )
                .applyNapzakFont(.caption1SemiBold12, lineSpacingEnabled: false)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .tint(Color.napzakGrayScale(.gray500))
                .autocorrectionDisabled()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.napzakGrayScale(.gray50))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
    
    private var phoneField: some View {
        HStack(spacing: 10) {
            Text("+82")
                .applyNapzakFont(.caption1SemiBold12)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
            
            TextField(
                "전화번호",
                text: $phoneNumberText,
                prompt: Text("010-1234-5678")
                    .font(.napzakFont(.caption1SemiBold12))
                    .foregroundColor(Color.napzakGrayScale(.gray200))
            )
            .applyNapzakFont(.caption1SemiBold12, lineSpacingEnabled: false)
            .foregroundStyle(Color.napzakGrayScale(.gray500))
            .tint(Color.napzakGrayScale(.gray500))
            .keyboardType(.numberPad)
            .onChange(of: phoneNumberText) { newValue in
                let normalizedValue = newValue.normalizedPhoneNumberInput
                let formattedValue = normalizedValue.formattedPhoneNumber

                if phoneNumberText != formattedValue {
                    phoneNumberText = formattedValue
                }

                if phoneNumber != normalizedValue {
                    phoneNumber = normalizedValue
                }
            }
            
            sendButton
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.napzakGrayScale(.gray50))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
    
    private var sendButton: some View {
        Button {
            onTapSendCode()
        } label: {
            Text(buttonTitle)
                .applyNapzakFont(.caption1SemiBold12)
                .foregroundStyle(Color.napzakGrayScale(.gray50))
                .frame(width: 64, height: 30)
                .background(buttonColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .disabled(isButtonDisabled)
    }
    
    private var buttonTitle: String {
        hasSentCode ? "재전송" : "인증하기"
    }

    private var isButtonDisabled: Bool {
        if hasSentCode {
            return !isResendEnabled || isSendingCode
        }

        return !isSendButtonEnabled || isSendingCode
    }

    private var buttonColor: Color {
        (!isButtonDisabled)
        ? .napzakPrimary(.purple500)
        : .napzakGrayScale(.gray200)
    }
}

#Preview("초기 상태") {
    PhoneInputSectionView(
        name: .constant(""),
        phoneNumber: .constant(""),
        isSendButtonEnabled: false,
        isResendEnabled: false,
        isSendingCode: false,
        hasSentCode: false,
        onTapSendCode: {}
    )
    .frame(height: 100)
}

#Preview("이름 입력만") {
    PhoneInputSectionView(
        name: .constant("홍길동"),
        phoneNumber: .constant(""),
        isSendButtonEnabled: false,
        isResendEnabled: false,
        isSendingCode: false,
        hasSentCode: false,
        onTapSendCode: {}
    )
    .padding(20)
}

#Preview("번호 입력 완료 (버튼 활성)") {
    PhoneInputSectionView(
        name: .constant("홍길동"),
        phoneNumber: .constant("01012345678"),
        isSendButtonEnabled: true,
        isResendEnabled: false,
        isSendingCode: false,
        hasSentCode: false,
        onTapSendCode: {}
    )
    .padding(20)
}

#Preview("인증 요청 중") {
    PhoneInputSectionView(
        name: .constant("홍길동"),
        phoneNumber: .constant("01012345678"),
        isSendButtonEnabled: false,
        isResendEnabled: false,
        isSendingCode: true,
        hasSentCode: false,
        onTapSendCode: {}
    )
    .padding(20)
}

#Preview("인증번호 발송 완료 (재전송 상태)") {
    PhoneInputSectionView(
        name: .constant("홍길동"),
        phoneNumber: .constant("01012345678"),
        isSendButtonEnabled: false,
        isResendEnabled: true,
        isSendingCode: false,
        hasSentCode: true,
        onTapSendCode: {}
    )
    .padding(20)
}
