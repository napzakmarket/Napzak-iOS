//
//  MixpanelManager.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 9/5/25.
//

import Foundation
import os
import Mixpanel

final class MixpanelManager {
    
    //MARK: - Properties
    
    static let shared = MixpanelManager()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "Mixpanel")
    
    //MARK: - Init
    
    private init() { }
    
}

extension MixpanelManager {
    
    //MARK: - Func
    
    func initializeMixpanel() {
        guard let token = Bundle.main.infoDictionary?["MIXPANEL_TOKEN"] as? String else { return }
        
        Mixpanel.initialize(token: token, trackAutomaticEvents: true)
    }
    
    func trackEvent(event: String, properties: [String: MixpanelType]? = nil) {
        Mixpanel.mainInstance().track(event: event, properties: properties)
    }
}
