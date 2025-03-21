//
//  FontLiterial.swift
//  Napzakm-iOS
//
//  Created by 조혜린 on 3/14/25.
//

import SwiftUI

enum FontWeight: String {
    case regular = "Pretendard-Regular"
    case medium = "Pretendard-Medium"
    case semiBold = "Pretendard-SemiBold"
    case bold = "Pretendard-Bold"
}

enum NapzakFontStyle {
    
    //title
    case title1Bold22
    case title2Bold20
    case title3Bold18
    
    //body
    case body1Bold16
    case body2SemiBold16
    case body3Regular16
    case body4Bold14
    case body5SemiBold14
    case body6Regular14
    
    //caption
    case caption1SemiBold12
    case caption2Medium12
    case caption3Regular12
}

extension Font {
    
    static func pretendardFont(weight: FontWeight, size: CGFloat) -> Font {
        Font.custom(weight.rawValue, size: size)
    }
    
    static func napzakFont(_ style: NapzakFontStyle) -> Font {
        switch style {
            
        //title
        case .title1Bold22: return pretendardFont(weight: .bold, size: 22)
        case .title2Bold20: return pretendardFont(weight: .bold, size: 20)
        case .title3Bold18: return pretendardFont(weight: .bold, size: 18)
            
        //body
        case .body1Bold16: return pretendardFont(weight: .bold, size: 16)
        case .body2SemiBold16: return pretendardFont(weight: .semiBold, size: 16)
        case .body3Regular16: return pretendardFont(weight: .regular, size: 16)
        case .body4Bold14: return pretendardFont(weight: .bold, size: 14)
        case .body5SemiBold14: return pretendardFont(weight: .semiBold, size: 14)
        case .body6Regular14: return pretendardFont(weight: .regular, size: 14)
            
        //caption
        case .caption1SemiBold12: return pretendardFont(weight: .semiBold, size: 12)
        case .caption2Medium12: return pretendardFont(weight: .medium, size: 12)
        case .caption3Regular12: return pretendardFont(weight: .regular, size: 12)
        }
    }
    
    static func toUIFont(_ style: NapzakFontStyle) -> UIFont {
        switch style {
            
        //title
        case .title1Bold22: return UIFont(name: FontWeight.bold.rawValue, size: 22)!
        case .title2Bold20: return UIFont(name: FontWeight.bold.rawValue, size: 20)!
        case .title3Bold18: return UIFont(name: FontWeight.bold.rawValue, size: 18)!
            
        //body
        case .body1Bold16: return UIFont(name: FontWeight.bold.rawValue, size: 16)!
        case .body2SemiBold16: return UIFont(name: FontWeight.semiBold.rawValue, size: 16)!
        case .body3Regular16: return UIFont(name: FontWeight.regular.rawValue, size: 16)!
        case .body4Bold14: return UIFont(name: FontWeight.bold.rawValue, size: 14)!
        case .body5SemiBold14: return UIFont(name: FontWeight.semiBold.rawValue, size: 14)!
        case .body6Regular14: return UIFont(name: FontWeight.regular.rawValue, size: 14)!
            
        //caption
        case .caption1SemiBold12: return UIFont(name: FontWeight.semiBold.rawValue, size: 12)!
        case .caption2Medium12: return UIFont(name: FontWeight.medium.rawValue, size: 12)!
        case .caption3Regular12: return UIFont(name: FontWeight.regular.rawValue, size: 12)!
        }
    }
}
