//
//  UsernameInputField.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/1/25.
//

import SwiftUI

struct UsernameInputField: View {
    @State private var username: String = ""
    @State private var validationState: UsernameValidation = .empty
    @State private var isButtonEnabled: Bool = false
    
    let pattern = "[^A-Za-z0-9가-힣ㄱ-ㅎㅏ-ㅣ]"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 16) {
                TextField(
                    "아이디",
                    text: $username,
                    prompt: Text("이름을 입력해주세요")
                        .foregroundStyle(Color.napzakGrayScale(.gray200))
                        .font(.napzakFont(.caption2Medium12))
                )
                .applyNapzakFont(.caption1SemiBold12)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                
                Button {
//                    활성화된 [이름 확인] 버튼 선택 시 다음 항목 검증:
//                    욕설/비속어 포함 여부
//                    이름 중복 여부
                    // TODO: 닉네임 검증 API 요청, debounce
                    print("서버로 이름 확인 요청: \(username)")
                    print("글자수: \(username.count)")
                } label: {
                    isButtonEnabled ? Image(.namecheckDefault) : Image(.namecheckDisabled)
                }
                .disabled(!isButtonEnabled)
            }
            .padding([.vertical, .trailing], 10)
            .padding(.leading, 16)
            .background(Color.napzakGrayScale(.gray50))
            .cornerRadius(8)
            
            
            HStack(spacing: 6) {
                Circle()
                    .fill(validationState.color)
                    .frame(width: 5, height: 5)
                
                Text(validationState.message)
                    .applyNapzakFont(.caption1SemiBold12)
                    .foregroundStyle(validationState.color)
            }
            
        }
        .onChange(of: username) { _, newValue in
            validateUsername(newValue)
        }
    }
}

extension UsernameInputField {
    private func validateUsername(_ name: String) {
        if name.count > 20 {
            username = String(name.prefix(20))
        }
        
        isButtonEnabled = false
        
        if name.isEmpty {
            validationState = .empty
        } else if name.contains(" ") {
            validationState = .invalidSapce
        } else if name.range(of: pattern, options: .regularExpression) != nil {
            validationState = .invalidSpecialChar
        } else {
            validationState = .valid
            isButtonEnabled = true
        }
    }
}

#Preview {
    UsernameInputField()
}
