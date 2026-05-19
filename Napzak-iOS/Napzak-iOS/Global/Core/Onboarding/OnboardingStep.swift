//
//  OnboardingStep.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/2/25.
//

import Foundation

enum OnboardingStep: String, CaseIterable, Hashable {
    case terms
    case phoneVerification
    case username
    case genre
    case completed

    var restorationPath: [OnboardingStep] {
        switch self {
        case .terms:
            return [.terms]
        case .phoneVerification:
            return [.terms, .phoneVerification]
        case .username:
            return [.terms, .phoneVerification, .username]
        case .genre:
            return [.terms, .phoneVerification, .username, .genre]
        case .completed:
            return [.completed]
        }
    }
}
