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
    case invalidSpecialChar
    case invalidNumberOnly
    case invalidIncompleteHangul
    case serverError(String)
    
    var color: Color {
        switch self {
        case .empty:
            return .clear
        case .valid:
            return Color.napzakState(.green)
        case .invalidSpecialChar, .invalidNumberOnly, .serverError, .invalidSpace, .invalidIncompleteHangul:
            return Color.napzakState(.red)
        }
    }
    
    var message: String {
        switch self {
        case .empty:
            return ""
        case .valid:
            return "사용 가능한 이름이에요"
        case .invalidSpecialChar:
            return "특수기호를 사용할 수 없어요."
        case .invalidNumberOnly:
            return "숫자만으로는 이름을 만들 수 없어요."
        case .invalidSpace:
            return "띄어쓰기를 포함할 수 없어요."
        case .invalidIncompleteHangul:
            return "완성되지 않은 글자는 사용할 수 없어요"
        case .serverError(let message):
            return message
        }
    }
}
