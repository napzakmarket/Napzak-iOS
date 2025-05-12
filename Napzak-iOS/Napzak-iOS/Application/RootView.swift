//
//  RootView.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/3/25.
//

import SwiftUI

struct RootView: View {
    @StateObject private var authRouter = AuthNavigationRouter()
    @StateObject private var navigationRouter = NavigationRouter()
    @StateObject private var tabRouter = TabRouter()
    @StateObject private var authManager = AuthManager.shared
    
    var body: some View {
        if authManager.isAuthenticated && !authManager.needsOnboarding {
            NZTabBarView()
                .environmentObject(navigationRouter)
                .environmentObject(tabRouter)
        } else {
            LoginView()
                .environmentObject(authRouter)
        }    
    }
}

#Preview {
    RootView()
}
