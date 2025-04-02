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
    @State private var isCheckButtonEnabled: Bool = false
    @Binding var isPrimaryButtonEnabled: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 16) {
                TextField(
                    "아이디",
                    text: $username,
                    prompt: Text("이름을 입력해주세요")
                        .foregroundColor(Color.napzakGrayScale(.gray200))
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
                    
                    isPrimaryButtonEnabled = true
                } label: {
                    isCheckButtonEnabled ? Image(.namecheckDefault) : Image(.namecheckDisabled)
                }
                .disabled(!isCheckButtonEnabled)
            }
            .padding([.vertical, .trailing], 10)
            .padding(.leading, 16)
            .background(Color.napzakGrayScale(.gray50))
            .cornerRadius(14)
            
            
            HStack(spacing: 6) {
                Circle()
                    .fill(validationState.color)
                    .frame(width: 5, height: 5)
                    .padding(.leading, 6)
                
                Text(validationState.message)
                    .applyNapzakFont(.caption1SemiBold12)
                    .foregroundStyle(validationState.color)
            }
            
        }
        .onChange(of: username) { newValue in
            validateUsername(newValue)
        }
    }
}

extension UsernameInputField {
    private func validateUsername(_ name: String) {
        if name.count > 20 {
            username = String(name.prefix(20))
        }
        
        let specialCharPattern = "[^A-Za-z0-9가-힣ㄱ-ㅎㅏ-ㅣ]"
        let numberOnlyPattern = "^[0-9]+$"
        
        isCheckButtonEnabled = false
        isPrimaryButtonEnabled = false
        
        if name.isEmpty {
            validationState = .empty
        } else if name.contains(" ") {
            validationState = .invalidSapce
        } else if name.range(of: specialCharPattern, options: .regularExpression) != nil {
            validationState = .invalidSpecialChar
        } else if name.range(of: numberOnlyPattern, options: .regularExpression) != nil {
            validationState = .invalidNumberOnly
        } else if !isValidUsername(name) {
            validationState = .empty
        } else {
            validationState = .valid
            isCheckButtonEnabled = true
        }
    }
    
    private func isValidUsername(_ name: String) -> Bool {
        let validPattern = "^(?=.*[가-힣]|[A-Za-z0-9])[가-힣A-Za-z0-9]{2,}$"
        let consonantVowelPattern = "^[ㄱ-ㅎㅏ-ㅣ]+$"
        
        guard name.range(of: consonantVowelPattern, options: .regularExpression) == nil else {
            return false
        }
        
        return name.range(of: validPattern, options: .regularExpression) != nil
    }
}

#Preview {
    UsernameInputField(isPrimaryButtonEnabled: .constant(true))
        .padding(.horizontal, 20)
}
