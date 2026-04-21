//
//  AnalyticsEvent.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/21/26.
//

import Foundation

public protocol AnalyticsEvent {
    var name: AnalyticsEventName { get }
    var parameters: [AnalyticsParameterKey: Any]? { get }
}
