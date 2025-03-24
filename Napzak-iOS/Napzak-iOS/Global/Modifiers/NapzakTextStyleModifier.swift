//
//  NapzakTextStyleModifier.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 3/25/25.
//

import SwiftUI

struct NapzakTextStyleModifier: ViewModifier {
    let fontSpacing: CGFloat
    let letterSpacing: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding(.vertical, fontSpacing)
            .lineSpacing(fontSpacing * 2)
            .tracking(letterSpacing)
    }
}
