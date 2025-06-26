//
//  UsernameValidation.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/1/25.
//

import SwiftUI

enum UsernameValidation: Equatable {
    case empty
    case valid
    case invalidSpace
    case invalidNumberOnly
    case invalidSpecialChar
    case invalidMinLength
    case invalidMaxLength
    case invalidIncompleteHangul
    case serverError(String)
    
    var message: String {
        switch self {
        case .empty:
            return ""
        case .valid:
            return "사용할 수 있는 이름이에요!"
        case .invalidSpace:
            return "띄어쓰기를 포함할 수 없어요."
        case .invalidNumberOnly:
            return "숫자만으로는 이름을 만들 수 없어요."
        case .invalidSpecialChar:
            return "특수기호를 사용할 수 없어요."
        case .invalidMinLength:
            return "최소 2자 이상 입력할 수 있어요."
        case .invalidMaxLength:
            return "최대 20자까지 입력할 수 있어요."
        case .invalidIncompleteHangul:
            return "이름은 ‘가’, ‘나’처럼 완성된 글자로만 입력해 주세요."
        case .serverError(let message):
            return message
        }
    }
    
    var color: Color {
        switch self {
        case .valid:
            return Color.napzakState(.green)
        case .invalidSpace,
                .invalidNumberOnly, .invalidSpecialChar, .invalidMinLength,
                .invalidMaxLength, .invalidIncompleteHangul, .empty, .serverError:
            return Color.napzakState(.red)
        }
    }
    
    var textColor: Color {
        switch self {
        case .empty, .valid:
            return Color.napzakGrayScale(.gray500)
        case .invalidSpace,
                .invalidNumberOnly, .invalidSpecialChar, .invalidMinLength,
                .invalidMaxLength, .invalidIncompleteHangul, .serverError:
            return Color.napzakState(.red)
        }
    }
}
