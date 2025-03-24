//
//  View+.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 3/25/25.
//

import SwiftUI

extension View {
    func applyNapzakTextStyle(napzakFontStyle: NapzakFontStyle) -> some View {
        let font = Font.toUIFont(napzakFontStyle)
        let fontSpacing: CGFloat = font.lineHeight / 100 * 28 / 4
        let letterSpacing: CGFloat = -0.2

        return self.modifier(NapzakTextStyleModifier(fontSpacing: fontSpacing, letterSpacing: letterSpacing))
    }
}
