//
//  UpdateManager.swift
//  Napzak-iOS
//
//  Created by 조호근 on 8/31/25.
//

import Foundation
import os
import FirebaseRemoteConfig

@MainActor
final class UpdateManager: ObservableObject {
    
    static let shared = UpdateManager()
    
    @Published var showUpdateAlert: Bool = false
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "UpdateManager")
    
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    init() {
        setupRemoteConfig()
    }
    
    private func setupRemoteConfig() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        
        remoteConfig.configSettings = settings
    }
    
    func checkAppVersion() async {
        do {
            let status = try await remoteConfig.fetchAndActivate()
            
            switch status {
            case .successFetchedFromRemote, .successUsingPreFetchedData:
                logger.info("Remote Config 구성이 성공적으로 활성화되었습니다 (상태: \(status.rawValue))")
                performVersionCheck()
                
            case .error:
                logger.error("Remote Config 구성 가져오기 또는 활성화 중 오류 발생")
                
            @unknown default:
                logger.warning("Remote Config 알 수 없는 상태입니다: \(status.rawValue)")
            }
            
        } catch {
            logger.error("Remote Config fetchAndActivate 실패: \(error.localizedDescription)")
        }
    }
    
    private func performVersionCheck() {
        guard let currentVersionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            logger.error("현재 앱 버전을 가져올 수 없습니다.")
            return
        }
        
        let minimumVersion = remoteConfig.configValue(forKey: "minimum_version").stringValue

        let currentMajorMinor = currentVersionString.split(separator: ".").prefix(2).joined(separator: ".")
        let minimumMajorMinor = minimumVersion.split(separator: ".").prefix(2).joined(separator: ".")

        if currentMajorMinor.compare(minimumMajorMinor, options: .numeric) == .orderedAscending {
            logger.info("강제 업데이트가 필요합니다. (현재: \(currentVersionString), 최소: \(minimumVersion))")
            self.showUpdateAlert = true
        } else {
            logger.info("앱이 최신 버전입니다. (현재: \(currentVersionString), 최소: \(minimumVersion))")
        }
    }
}
