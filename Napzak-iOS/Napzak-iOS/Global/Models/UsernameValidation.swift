//
//  UsernameValidation.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/1/25.
//

import SwiftUI

enum UsernameValidation {
    case valid
    case empty
    case invalidSapce
    case invalidSpecialChar
    case invalidProfanity
    case invalidDuplicate
    case invalidNumberOnly
    
    var message: String {
        switch self {
        case .valid:
            return "사용할 수 있는 이름이에요!"
        case .invalidSapce:
            return "띄어쓰기를 포함할 수 없어요."
        case .invalidSpecialChar:
            return "특수기호를 사용할 수 없어요."
        case .invalidProfanity:
            return "욕설이나 비속어를 사용할 수 없어요."
        case .invalidDuplicate:
            return "이미 사용중인 이름이에요."
        case .invalidNumberOnly:
            return "숫자만으로 구성된 이름을 사용할 수 없어요."
        case .empty:
            return ""
        }
    }
    
    var color: Color {
        switch self {
        case .valid:
            return Color.napzakState(.green)
        case .invalidSapce, .invalidSpecialChar, .invalidProfanity, .invalidDuplicate, .invalidNumberOnly:
            return Color.napzakState(.red)
        case .empty:
            return .clear
        }
    }
}
