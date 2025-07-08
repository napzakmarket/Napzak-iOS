//
//  InterestService.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/28/25.
//

import Foundation
import Moya

protocol InterestServiceProtocol {
    func postInterest(productId: Int) async -> Result<Void, NetworkError>
    func deleteInterest(productId: Int) async -> Result<Void, NetworkError>
}

final class InterestService: BaseService, InterestServiceProtocol {
    
    private let provider = MoyaProvider<InterestAPI>.init(plugins: [MoyaPlugin()])
    
    
    func postInterest(productId: Int) async -> Result<Void, NetworkError> {
        return await requestVoid(provider, .postInterest(productId: productId))
    }
    
    func deleteInterest(productId: Int) async -> Result<Void, NetworkError> {
        return await requestVoid(provider, .deleteInterest(productId: productId))
    }
}
