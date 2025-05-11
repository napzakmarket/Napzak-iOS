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
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "SettingView")
    private let networkService = NetworkService.shared.authService
}


// MARK: - LogOut

extension SettingViewModel {
    func logOut() async {
        let result = await networkService.logout()
        
        switch result {
        case .success(let response):
            logger.info("📦 [LogOut] code: \(response.status)")
            logger.info("📦 [LogOut] message: \(response.message)")
        case .failure(let error):
            logger.error("❌ [LogOut] failed: \(error.localizedDescription)")
        }
    }
}
