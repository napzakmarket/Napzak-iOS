//
//  View+.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 3/25/25.
//

import SwiftUI

extension View {
    func applyNapzakFont(_ style: NapzakFontStyle, lineSpacingEnabled: Bool = true) -> some View {
        let font = Font.toUIFont(style)
        let fontSpacing: CGFloat = font.lineHeight * 0.28 / 2
        let letterSpacing: CGFloat = font.pointSize * (-0.02)

        return self
            .font(.napzakFont(style))
            .padding(.vertical, lineSpacingEnabled ? fontSpacing : 0)
            .lineSpacing(lineSpacingEnabled ? fontSpacing * 2 : 0)
            .tracking(letterSpacing)
    }
    
    func swipePopGestureDisabled() -> some View {
        modifier(SwipePopGestureDisabledViewModifier())
    }
    
    func dismissKeyboard() {
        UIApplication.shared
            .sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func centerInParent() -> some View {
        GeometryReader { geometry in
            self
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
    
    func appAlert(
        isPresented: Binding<Bool>,
        style: AppAlertView.Style,
        onConfirm: @escaping () -> Void
    ) -> some View {
        self.modifier(AppAlertOverlayModifier(isPresented: isPresented, style: style, onConfirm: onConfirm))
    }
}
