//
//  OnboardingManager.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/2/25.
//

import Foundation

final class OnboardingManager {
    static let shared = OnboardingManager()
    
    private init() {}
    
    private let defaults = UserDefaults.standard
    private let checkpointKey = "onboarding_Checkpoint"
    private let lastActiveKey = "onboarding_LastActive"
    
    func saveCheckpoint(_ step: OnboardingStep) {
        defaults.set(step.rawValue, forKey: checkpointKey)
        defaults.set(Date(), forKey: lastActiveKey)
    }
    
    func getLastCheckpoint() -> OnboardingStep? {
        if let lastActive = defaults.object(forKey: lastActiveKey) as? Date,
           Date().timeIntervalSince(lastActive) > 24 * 60 * 60 {
            clearProgress()
            return nil
        }
        guard let raw = defaults.string(forKey: checkpointKey),
              let step = OnboardingStep(rawValue: raw) else {
            return nil
        }
        
        return step
    }
    
    func clearProgress() {
        defaults.removeObject(forKey: checkpointKey)
        defaults.removeObject(forKey: lastActiveKey)
    }
}
