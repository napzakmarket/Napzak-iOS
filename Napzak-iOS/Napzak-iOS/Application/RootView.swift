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
    @State private var isShowingSplash = true
    
    var body: some View {
        Group {
            if isShowingSplash {
                SplashView()
                    .transition(.opacity)
            } else if authManager.isAuthenticated && !authManager.needsOnboarding {
                NZTabBarView()
                    .environmentObject(navigationRouter)
                    .environmentObject(tabRouter)
            } else {
                LoginView()
                    .environmentObject(authRouter)
            }
//            NZTabBarView()
//                .environmentObject(navigationRouter)
//                .environmentObject(tabRouter)
        }
        .onAppear {
            isShowingSplash = true
            
            Task {
                try? await Task.sleep(for: .seconds(2.5))
                await MainActor.run {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isShowingSplash = false
                    }
                }
            }
        }
    }
}

#Preview {
    RootView()
}
