//
//  BaseService.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/28/25.
//

import Foundation

import Moya

class BaseService {
    
    /// 200 받았을 때 decoding 할 데이터가 있는 경우 (대부분의 GET)
    func fetchNetworkResult<T: Decodable>(statusCode: Int, data: Data) -> NetworkResult<T> {
        switch statusCode {
        case 200, 201, 204:
            if let decodedData = fetchDecodeData(data: data, responseType: T.self) {
                return .success(decodedData)
            } else { return .decodeErr }
        case 400: return .badRequest
        case 401: return .unAuthorized
        case 404: return .notFound
        case 500: return .internalServerErr
        default: return .networkFail
        }
    }
    
    /// 200 받았을 때 decoding 할 데이터가 없는 경우 (대부분의 PATCH, PUT, DELETE)
    func fetchNetworkResult(statusCode: Int, data: Data) -> NetworkResult<Any> {
        switch statusCode {
        case 200, 201, 204: return .success(nil)
        case 400: return .badRequest
        case 401: return .unAuthorized
        case 404: return .notFound
        case 500: return .internalServerErr
        default: return .networkFail
        }
    }
    
    func fetchDecodeData<T: Decodable>(data: Data, responseType: T.Type) -> T? {
        let decoder = JSONDecoder()
        if let decodedData = try? decoder.decode(responseType, from: data){
            return decodedData
        } else {
            print("decoding error🤮🤮🤮🤮")
            return nil
        }
    }
    
    
    //디코딩할 데이터가 있는 경우에서의 request 함수
    func request<T: Decodable, Target: BaseTargetType>(_ provider: MoyaProvider<Target>, _ apiTarget: Target, completion: @escaping (NetworkResult<T>) -> ()) {
        provider.request(apiTarget) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<T> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    //디코딩할 데이터가 없는 경우에서의 request 함수
    func request<Target: BaseTargetType>(_ provider: MoyaProvider<Target>, _ apiTarget: Target, completion: @escaping (NetworkResult<Any>) -> ()) {
        provider.request(apiTarget) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<Any> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
}
