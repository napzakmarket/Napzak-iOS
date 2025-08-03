//
//  PushOffState.swift
//  Napzak-iOS
//
//  Created by 조호근 on 7/14/25.
//

import Foundation

enum PushOffState: String {
    case appOnlyOff
    case osOnlyOff
    case bothOff
    
    var message: String {
        switch self {
        case .appOnlyOff:
            return "앱 내 알림이 꺼져있어요!"
        case .osOnlyOff:
            return "기기 알림이 꺼져있어요!"
        case .bothOff:
            return "앱과 기기 알림이 모두 꺼져있어요!"
        }
    }
}
