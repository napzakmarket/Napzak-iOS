//
//  PushPermissionService.swift
//  Napzak-iOS
//
//  Created by 조호근 on 7/8/25.
//

import Foundation

@MainActor
protocol PushPermissionService {
    var isAppPushEnabled: Bool { get set }
    var isOSPushEnabled:  Bool { get set }
    var shouldShowPush:   Bool { get }
    func refreshOSPushStatus() async
    func requestNotificationPermission() async -> Bool
}
