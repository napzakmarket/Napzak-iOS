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
    
    let isSendButtonEnabled: Bool
    let isSendingCode: Bool
    let hasSentCode: Bool
    
    let onTapSendCode: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            nameField
            phoneField
        }
    }
}

extension PhoneInputSectionView {
    private var nameField: some View {
        TextField(
            "",
            text: $name,
            prompt: Text("이름")
                .font(.napzakFont(.caption2Medium12))
                .foregroundColor(Color.napzakGrayScale(.gray200))
        )
        .applyNapzakFont(.caption1SemiBold12)
        .foregroundStyle(Color.napzakGrayScale(.gray500))
        .tint(Color.napzakGrayScale(.gray500))
        .autocorrectionDisabled()
        .padding(.horizontal, 16)
        .padding(.vertical, 18)
        .background(Color.napzakGrayScale(.gray50))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
    
    private var phoneField: some View {
        HStack(spacing: 10) {
            Text("+82")
                .applyNapzakFont(.caption1SemiBold12)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
            
            TextField(
                "",
                text: $phoneNumber,
                prompt: Text("010-1234-5678")
                    .font(.napzakFont(.caption2Medium12))
                    .foregroundColor(Color.napzakGrayScale(.gray200))
            )
            .applyNapzakFont(.caption1SemiBold12)
            .foregroundStyle(Color.napzakGrayScale(.gray500))
            .tint(Color.napzakGrayScale(.gray500))
            .keyboardType(.numberPad)
            .padding(.vertical, 18)
            
            sendButton
        }
        .padding(.horizontal, 16)
        
        .background(Color.napzakGrayScale(.gray50))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
    
    private var sendButton: some View {
        Button {
            onTapSendCode()
        } label: {
            Text(hasSentCode ? "재전송" : "인증하기")
                .applyNapzakFont(.caption1SemiBold12)
                .foregroundStyle(Color.napzakGrayScale(.gray50))
                .frame(width: 64, height: 30)
                .background(buttonColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .disabled(!isSendButtonEnabled || isSendingCode)
    }
    
    private var buttonColor: Color {
        (isSendButtonEnabled && !isSendingCode)
        ? .napzakPrimary(.purple500)
        : .napzakGrayScale(.gray200)
    }
}

#Preview("초기 상태") {
    PhoneInputSectionView(
        name: .constant(""),
        phoneNumber: .constant(""),
        isSendButtonEnabled: false,
        isSendingCode: false,
        hasSentCode: false,
        onTapSendCode: {}
    )
    .padding(20)
}

#Preview("이름 입력만") {
    PhoneInputSectionView(
        name: .constant("홍길동"),
        phoneNumber: .constant(""),
        isSendButtonEnabled: false,
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
        isSendingCode: false,
        hasSentCode: true,
        onTapSendCode: {}
    )
    .padding(20)
}
