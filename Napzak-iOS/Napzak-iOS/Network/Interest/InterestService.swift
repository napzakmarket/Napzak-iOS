//
//  InterestService.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/28/25.
//

import Moya

protocol InterestServiceProtocol {
    func postInterest(productId: Int, completion: @escaping (NetworkResult<Any>) -> ())
    func deleteInterest(productId: Int, completion: @escaping (NetworkResult<Any>) -> ())
}

final class InterestService: BaseService, InterestServiceProtocol {
    
    private let provider = MoyaProvider<InterestAPI>.init(plugins: [MoyaPlugin()])
    
    func postInterest(productId: Int, completion: @escaping (NetworkResult<Any>) -> ()) {
        request(provider, .postInterest(productId: productId), completion: completion)
    }
    
    func deleteInterest(productId: Int, completion: @escaping (NetworkResult<Any>) -> ()) {
        request(provider, .deleteInterest(productId: productId), completion: completion)
    }
}
