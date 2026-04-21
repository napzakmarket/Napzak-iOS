//
//  AnalyticsService.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/21/26.
//

import Foundation

public protocol AnalyticsService: Sendable {
    func initialize()
    func sendEvent(name: String, parameters: [String: Any]?) async
}
