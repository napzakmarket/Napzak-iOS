//
//  AppAlertOverlayModifier.swift
//  Napzak-iOS
//
//  Created by 조호근 on 8/25/25.
//

import SwiftUI

struct AppAlertOverlayModifier: ViewModifier {
    @Binding var isPresented: Bool
    var style: AppAlertView.Style
    var onConfirm: () -> Void

    func body(content: Content) -> some View {
        content
            .disabled(isPresented)
            .overlay {
                if isPresented {
                    ZStack {
                        Color.black.opacity(0.45)
                            .ignoresSafeArea()
                            .transition(.opacity)

                        AppAlertView(style: style, onConfirm: onConfirm)
                            .frame(width: 284)
                            .transition(.scale.combined(with: .opacity))
                    }
                    .animation(.spring(response: 0.32, dampingFraction: 0.88), value: isPresented)
                }
            }
    }
}
