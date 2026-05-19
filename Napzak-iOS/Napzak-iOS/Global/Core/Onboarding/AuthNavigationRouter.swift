//
//  AuthNavigationRouter.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/3/25.
//

import SwiftUI

final class AuthNavigationRouter: ObservableObject {
    @Published var path = NavigationPath()
    
    var temporaryUsername: String?
    
    func push(next step: OnboardingStep) {
        path.append(step)
    }

    func replacePath(with steps: [OnboardingStep]) {
        var newPath = NavigationPath()
        for step in steps {
            newPath.append(step)
        }
        path = newPath
    }
    
    func pop() {
        path.removeLast()
    }
    
    func reset() {
        temporaryUsername = nil
        path = NavigationPath()
    }
}
