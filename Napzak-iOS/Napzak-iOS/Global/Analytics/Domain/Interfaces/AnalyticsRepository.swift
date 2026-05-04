//
//  AnalyticsRepository.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/21/26.
//

import Foundation

public protocol AnalyticsRepository: Sendable {
    func logEvent(_ event: AnalyticsEvent) async
}
