//
//  UsernameInputField.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/1/25.
//

import SwiftUI

struct UsernameInputField: View {
    @Binding var validationState: UsernameValidation
    @Binding var username: String
    @Binding var isPrimaryButtonEnabled: Bool
    
    var onCheckButtonTapped: (String) -> Void
    
    private var isCheckButtonEnabled: Bool {
        !username.isEmpty && username.count >= 2
    }
    
    private var textColor: Color {
        switch validationState {
        case .empty, .valid:
            return Color.napzakGrayScale(.gray500)
        case .invalidSpace, .invalidSpecialChar, .invalidNumberOnly, .serverError, .invalidIncompleteHangul:
            return Color.napzakState(.red)
        }
    }
    
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
                .foregroundStyle(textColor)
                .tint(Color.napzakGrayScale(.gray500))
                
                Button {
                    print("서버로 이름 확인 요청: \(username)")
                    print("글자수: \(username.count)")
                    
                    validateAndSubmit()
                } label: {
                    isCheckButtonEnabled ? Image(.namecheckDefault) : Image(.namecheckDisabled)
                }
                .disabled(!isCheckButtonEnabled)
            }
            .padding([.vertical, .trailing], 10)
            .padding(.leading, 16)
            .background(Color.napzakGrayScale(.gray50))
            .cornerRadius(14)
            
            VStack(spacing: 0) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(validationState.color)
                        .frame(width: 5, height: 5)
                        .padding(.leading, 6)
                    
                    Text(validationState.message)
                        .applyNapzakFont(.caption1SemiBold12)
                        .foregroundStyle(validationState.color)
                }
                
                Text(validationState == .invalidNumberOnly ? " 한글이나 영문을 함께 사용해주세요." : "")
                    .applyNapzakFont(.caption1SemiBold12)
                    .foregroundStyle(validationState.color)
                    .padding(.leading, 12)
            }
        }
        .onChange(of: username) { _ in
            validationState = .empty
            isPrimaryButtonEnabled = false
        }
    }
}

extension UsernameInputField {
    private func validateAndSubmit() {
        
        if username.contains(" ") {
            validationState = .invalidSpace
            isPrimaryButtonEnabled = false
            return
        }
        
        if containsIncompleteHangul(username) {
            validationState = .invalidIncompleteHangul
            isPrimaryButtonEnabled = false
            return
        }

        let specialCharPattern = "[^A-Za-z0-9가-힣]"
        let numberOnlyPattern = "^[0-9]+$"
        
        if username.range(of: specialCharPattern, options: .regularExpression) != nil {
            validationState = .invalidSpecialChar
            isPrimaryButtonEnabled = false
            return
        }
        
        if username.range(of: numberOnlyPattern, options: .regularExpression) != nil {
            validationState = .invalidNumberOnly
            isPrimaryButtonEnabled = false
            return
        }
        
        onCheckButtonTapped(username)
    }
    
    private func containsIncompleteHangul(_ text: String) -> Bool {
        let chosung = "ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ"
        let jungsung = "ㅏㅐㅑㅒㅓㅔㅕㅖㅗㅘㅙㅚㅛㅜㅝㅞㅟㅠㅡㅢㅣ"
        
        return text.contains { char in
            String(char).rangeOfCharacter(from: CharacterSet(charactersIn: chosung + jungsung)) != nil
        }
    }
}

#Preview {
    UsernameInputField(
        validationState: .constant(.empty),
        username: .constant(""),
        isPrimaryButtonEnabled: .constant(false),
        onCheckButtonTapped: { _ in }
    )
    .padding(.horizontal, 20)
}
