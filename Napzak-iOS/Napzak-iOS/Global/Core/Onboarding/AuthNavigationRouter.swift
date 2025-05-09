//
//  AuthNavigationRouter.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/3/25.
//

import SwiftUI

final class AuthNavigationRouter: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(next step: OnboardingStep) {
        path.append(step)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func reset() {
        path = NavigationPath()
    }
}
