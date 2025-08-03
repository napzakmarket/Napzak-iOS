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
    var initialNickname: String? = nil
    
    var onCheckButtonTapped: (String) -> Void
    
    private let maxLength = 20
    
    private var isCheckButtonEnabled: Bool {
        let isChanged = (initialNickname == nil) || (username != initialNickname!)
        return isChanged && validateInput(username) == .empty && username.count >= 2 && username.count <= maxLength
    }
    
    private var shouldShowValidationMessage: Bool {
        validationState != .empty
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
                .foregroundStyle(validationState.textColor)
                .tint(Color.napzakGrayScale(.gray500))
                .onChange(of: username) { newValue in
                    if newValue.count > maxLength {
                        username = String(newValue.prefix(maxLength))
                    }
                }
                
                Button {
                    onCheckButtonTapped(username)
                } label: {
                    isCheckButtonEnabled ? Image(.namecheckDefault) : Image(.namecheckDisabled)
                }
                .disabled(!isCheckButtonEnabled)
            }
            .padding([.vertical, .trailing], 10)
            .padding(.leading, 16)
            .background(Color.napzakGrayScale(.gray50))
            .cornerRadius(14)
            
            VStack(alignment: .leading, spacing: 0) {
                if shouldShowValidationMessage {
                    HStack(alignment: .center, spacing: 0) {
                        HStack(spacing: 6) {
                            Circle()
                                .fill(validationState.color)
                                .frame(width: 5, height: 5)
                                .padding(.leading, 6)
                            
                            Text(validationState.message)
                                .applyNapzakFont(.caption1SemiBold12)
                                .foregroundStyle(validationState.color)
                        }
                        .frame(height: 15)
                        
                        Spacer(minLength: 8)
                        
                        Text("\(username.count)/\(maxLength)")
                            .applyNapzakFont(.caption5Regular10)
                            .foregroundColor(.napzakGrayScale(.gray300))
                            .frame(width: 45, alignment: .trailing)
                            .padding(.trailing, 16)
                    }
                } else {
                    HStack {
                        Spacer()
                        Text("\(username.count)/\(maxLength)")
                            .applyNapzakFont(.caption5Regular10)
                            .foregroundColor(.napzakGrayScale(.gray300))
                            .frame(width: 45, alignment: .trailing)
                            .padding(.trailing, 16)
                    }
                }
                
                Text(validationState == .invalidNumberOnly ? "한글이나 영문을 함께 사용해주세요." : "")
                    .applyNapzakFont(.caption1SemiBold12)
                    .foregroundStyle(validationState.color)
                    .padding(.leading, 16)

            }
        }
        .onChange(of: username) { newValue in
            switch validationState {
            case .valid, .serverError:
                isPrimaryButtonEnabled = false
            default:
                break
            }
            
            validationState = validateInput(newValue)
        }
    }
}

extension UsernameInputField {
    private func validateInput(_ text: String) -> UsernameValidation {
        // 길이 체크
        if text.isEmpty {
            return .empty
        }
        
        if text.count < 2 {
            return .invalidMinLength
        }
        
        if text.count > maxLength {
            return .invalidMaxLength
        }
        
        // 띄어쓰기 체크
        if text.contains(" ") {
            return .invalidSpace
        }
        
        // 초성/중성만 있는지 체크
        if containsIncompleteHangul(text) {
            return .invalidIncompleteHangul
        }
        
        // 특수문자 체크
        let specialCharPattern = "[^A-Za-z0-9가-힣]"
        if text.range(of: specialCharPattern, options: .regularExpression) != nil {
            return .invalidSpecialChar
        }
        
        // 숫자만 있는지 체크
        let numberOnlyPattern = "^[0-9]+$"
        if text.range(of: numberOnlyPattern, options: .regularExpression) != nil {
            return .invalidNumberOnly
        }
        
        // 모든 클라이언트 검증 통과
        return .empty
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
        validationState: .constant(.invalidNumberOnly),
        username: .constant("11"),
        isPrimaryButtonEnabled: .constant(false),
        onCheckButtonTapped: { _ in }
    )
    .padding(.horizontal, 20)
}
