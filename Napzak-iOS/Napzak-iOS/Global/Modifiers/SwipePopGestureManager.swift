//
//  SwipePopGestureManager.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/14/25.
//

import SwiftUI

final class SwipePopGestureManager {

    // Singleton 객체 생성
    static let shared = SwipePopGestureManager()
    private init() {}
    
    // 뒤로가기 제스처를 허용하는지 확인 변수
    private(set) var isAllowPopGesture = true
    
    // 뒤로가기 제스처를 허용하는 변수 업데이트
    func updateAllowPopGesture(_ bool: Bool) {
        isAllowPopGesture = bool
    }
}

struct SwipePopGestureDisabledViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .task {
                SwipePopGestureManager.shared.updateAllowPopGesture(false)
            }
            .onDisappear {
                SwipePopGestureManager.shared.updateAllowPopGesture(true)
            }
    }
}
