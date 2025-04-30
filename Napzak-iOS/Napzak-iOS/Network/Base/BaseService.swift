//
//  BaseService.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/28/25.
//

import Foundation
import Moya
import os

class BaseService {
    private static var logger: Logger {
        Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "Network.Service")
    }
    
    func request<T: Decodable, Target: BaseTargetType>(_ provider: MoyaProvider<Target>,
                                                      _ target: Target) async -> Result<T, NetworkError> {
        await withCheckedContinuation { continuation in
            Self.logger.debug("Requesting: \(target.path)")
            
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    Self.logger.debug("Response received: \(response.statusCode)")
                    
                    switch response.statusCode {
                    case 200...299:
                        do {
                            let decodedData = try JSONDecoder().decode(T.self, from: response.data)
                            continuation.resume(returning: .success(decodedData))
                        } catch {
                            Self.logger.error("Decoding error: \(error.localizedDescription)")
                            continuation.resume(returning: .failure(.decodingError))
                        }
                    case 400:
                        continuation.resume(returning: .failure(.badRequest))
                    case 401:
                        continuation.resume(returning: .failure(.unauthorized))
                    case 404:
                        continuation.resume(returning: .failure(.notFound))
                    case 500...599:
                        continuation.resume(returning: .failure(.internalServerError))
                    default:
                        continuation.resume(returning: .failure(.networkFail))
                    }
                    
                case .failure(let error):
                    Self.logger.error("Network error: \(error.localizedDescription)")
                    continuation.resume(returning: .failure(.networkFail))
                }
            }
        }
    }
    
    func request<Target: BaseTargetType>(_ provider: MoyaProvider<Target>,
                                        _ target: Target) async -> Result<Void, NetworkError> {
        await withCheckedContinuation { continuation in
            Self.logger.debug("Requesting: \(target.path)")
            
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    Self.logger.debug("Response received: \(response.statusCode)")
                    
                    switch response.statusCode {
                    case 200...299:
                        continuation.resume(returning: .success(()))
                    case 400:
                        continuation.resume(returning: .failure(.badRequest))
                    case 401:
                        continuation.resume(returning: .failure(.unauthorized))
                    case 404:
                        continuation.resume(returning: .failure(.notFound))
                    case 500...599:
                        continuation.resume(returning: .failure(.internalServerError))
                    default:
                        continuation.resume(returning: .failure(.networkFail))
                    }
                    
                case .failure(let error):
                    Self.logger.error("Network error: \(error.localizedDescription)")
                    continuation.resume(returning: .failure(.networkFail))
                }
            }
        }
    }
}
