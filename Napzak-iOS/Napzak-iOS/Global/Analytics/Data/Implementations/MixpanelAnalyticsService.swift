//
//  MixpanelAnalyticsService.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/21/26.
//

import Foundation
import Mixpanel

public final class MixpanelAnalyticsService: AnalyticsService {
    public init() {}
    
    public func initialize() {
        guard let token = Bundle.main.infoDictionary?["MIXPANEL_TOKEN"] as? String else { return }
        Mixpanel.initialize(token: token, trackAutomaticEvents: true)
    }
    
    /// 믹스패널 이벤트를 보내는 함수입니다.
    ///
    /// Mixpanel은 독자적인 타입인 MixpanelType을 사용하므로 변환 과정이 필요합니다.
    /// 지원하는 자료형은 다음과 같습니다.
    /// String, Int, UInt, Double, Float, Bool, [MixpanelType], [String: MixpanelType],
    /// Date, URL, or NSNull. Numbers are not NaN or infinity
    ///
    /// 공식문서 링크
    /// https://mixpanel.github.io/mixpanel-swift/Protocols/MixpanelType.html
    ///
    /// - Parameters:
    ///   - name: 이벤트의 이름입니다. 이벤트 이름 목록은 AnalyticsEventName 엔티티 파일에 위치합니다.
    ///   - parameters: 이벤트에 따라 로깅할 값입니다. MixpanelType으로 변환하여 사용합니다.
    public func sendEvent(name: String, parameters: [String: Any]?) async {
        var mixpanelProperties: [String: MixpanelType] = [:]
        
        parameters?.forEach { key, value in
            if let mixpanelValue = value as? MixpanelType {
                mixpanelProperties[key] = mixpanelValue
            } else if let arrayValue = value as? [String] {
                mixpanelProperties[key] = arrayValue
            }
        }
        
        Mixpanel.mainInstance().track(event: name, properties: mixpanelProperties)
    }
}
