//
//  DefaultAnalyticsRepository.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/21/26.
//

import Foundation

public final class DefaultAnalyticsRepository: AnalyticsRepository {
    private let service: AnalyticsService
    
    public init(service: AnalyticsService) {
        self.service = service
    }
    
    public func logEvent(_ event: AnalyticsEvent) async {
        let eventName = event.name.value
        var parsedParameters: [String: Any]?
        
        if let parameters = event.parameters {
            parsedParameters = [:]
            for (key, value) in parameters {
                parsedParameters?[key.name] = value
            }
        }
        
        await service.sendEvent(name: eventName, parameters: parsedParameters)
    }
}
