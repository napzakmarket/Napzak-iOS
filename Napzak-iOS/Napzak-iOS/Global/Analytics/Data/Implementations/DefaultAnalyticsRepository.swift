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


// MARK: - Dependency

extension DefaultAnalyticsRepository {
    /// 싱글톤(shared)이라는 이름 대신, 실서비스용 객체라는 의미의 live 사용
    /// 지연 초기화 방식으로 실제 사용 시점부터 메모리에 올라가고 하나의 객체를 재사용
    /// 기존 Napzak_iOSApp의 init에서 선언하는 방식에 비해 앱 초기 구동 속도에 이점이 있음
    /// DIContainer등을 활용하는 방향으로 개선하면 이상적이겠으나, 규모가 너무 커서 이 방안으로 타협했음 ㅜ
    public static let live: AnalyticsRepository = {
        let service = MixpanelAnalyticsService()
        service.initialize()
        return DefaultAnalyticsRepository(service: service)
    }()
}
