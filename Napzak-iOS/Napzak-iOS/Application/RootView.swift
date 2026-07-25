//
//  RootView.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/3/25.
//

import SwiftUI

struct RootView: View {
    @StateObject private var authRouter = AuthNavigationRouter()
    @StateObject private var updateManager = UpdateManager()
    @EnvironmentObject private var phoneVerificationManager: PhoneVerificationManager
    
    @ObservedObject private var authManager = AuthManager.shared
    @State private var isShowingSplash = true
    @State private var hasStartedAuthenticatedSession = false
    
    let appID = "6740986515"
    var body: some View {
        Group {
            if isShowingSplash || authManager.isRestoringSession {
                SplashView()
                    .transition(.opacity)
            } else if authManager.isAuthenticated && !authManager.needsOnboarding {
                NZTabBarView()
            } else {
                LoginView()
                    .environmentObject(authRouter)
            }
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
                
                await updateManager.checkAppVersion()
            }

            if authManager.isAuthenticated {
                handleAuthenticatedSessionStart()
            } else {
                phoneVerificationManager.reset()
            }
        }
        .onChange(of: authManager.isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                handleAuthenticatedSessionStart()
            } else {
                hasStartedAuthenticatedSession = false
                phoneVerificationManager.reset()
            }
        }
        .appAlert(
            isPresented: $updateManager.showUpdateAlert,
            style: .update,
            onConfirm: {
                openAppStore()
            }
        )
    }
}

extension RootView {
    private func handleAuthenticatedSessionStart() {
        guard hasStartedAuthenticatedSession == false else { return }
        hasStartedAuthenticatedSession = true
        phoneVerificationManager.reset()

        Task {
            await authManager.fetchMyStoreId()
            guard authManager.isAuthenticated else { return }
            await authManager.fetchChatRoomIdsToWebSocket()
            guard authManager.isAuthenticated else { return }
            await phoneVerificationManager.refreshStatus()
        }
    }

    private func openAppStore() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(appID)") {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    RootView()
}
