//
//  View+.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 3/25/25.
//

import SwiftUI

extension View {
    func applyNapzakFont(_ style: NapzakFontStyle) -> some View {
        let font = Font.toUIFont(style)
        let fontSpacing: CGFloat = font.lineHeight * 0.28 / 2
        let letterSpacing: CGFloat = font.pointSize * (-0.02)
        
        return self
            .font(.napzakFont(style))
            .padding(.vertical, fontSpacing)
            .lineSpacing(fontSpacing * 2)
            .tracking(letterSpacing)
    }
    
    func swipePopGestureDisabled() -> some View {
        modifier(SwipePopGestureDisabledViewModifier())
    }
}
