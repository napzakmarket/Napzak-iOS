//
//  SettingViewModel.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/11/25.
//

import SwiftUI
import os

@MainActor
final class SettingViewModel: ObservableObject {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "SettingViewModel")
    private let authManager = AuthManager.shared
}


// MARK: - LogOut

extension SettingViewModel {
    func logout() async {
        let result = await AuthManager.shared.logout()
        
        switch result {
        case .success:
            logger.info("[Logout] 성공")
            
            ChatStompManager.shared.disconnect()

        case .failure(let error):
            logger.error("[Logout] 실패: \(error.localizedDescription)")
        }
    }
}
