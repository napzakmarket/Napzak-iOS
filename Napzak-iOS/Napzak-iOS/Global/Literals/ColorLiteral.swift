//
//  ColorLiteral.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 3/14/25.
//

import SwiftUI

enum Primary: String {
    case purple100 = "F1EAFF"
    case purple200 = "C8AEFF"
    case purple300 = "7534FF"
}

enum GrayScale: String {
    case white = "FFFFFF"
    case gray50 = "F5F5F5"
    case gray100 = "D9D9D9"
    case gray200 = "BCBCBC"
    case gray300 = "7F7F7F"
    case gray400 = "545454"
    case gray500 = "1A1A1A"
    case black = "2C2C2C"
}

enum State: String {
    case red = "EF4849"
    case green = "1BD368"
}

enum Transparency: String {
    case purple100 = "F1EAFF"
    case purple300 = "7534FF"
    case gray500 = "1A1A1A"
}

extension Color {
    init(hex: String, opacity: Double = 1.0) {
        let hexCode: Int = Int(hex, radix: 16)!
        let red = Double((hexCode >> 16) & 0xff) / 255
        let green = Double((hexCode >> 8) & 0xff) / 255
        let blue = Double((hexCode >> 0) & 0xff) / 255

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
    
    static func napzakPirmary(_ color: Primary) -> Color {
        return Color(hex: color.rawValue)
    }
    
    static func napzakGrayScale(_ color: GrayScale) -> Color {
        return Color(hex: color.rawValue)
    }
    
    static func napzakState(_ color: State) -> Color {
        return Color(hex: color.rawValue)
    }
    
    static func napzakTransparency(_ color: Transparency) -> Color {
        let opacity = 0.7
        return Color(hex: color.rawValue, opacity: opacity)
    }
}
