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
    typealias RefreshTask = _Concurrency.Task
    
    private static var logger: Logger {
        Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "Network.Service")
    }
    
    /// 네트워크 요청을 수행하고 제네릭 타입으로 응답 데이터를 디코딩합니다.
    ///
    ///    - HTTP 200~299 상태 코드는 `JSONDecoder`를 통해 `T` 타입으로 디코딩하여 반환합니다.
    ///    - HTTP 401 Unauthorized + `retry == true`인 경우,
    ///      `RefreshTask`를 사용해 비동기로 토큰을 재발급(`TokenRefresher.shared.refresh()`)하고
    ///      성공 시 동일한 요청을 `retry: false`로 재시도합니다.
    ///    - 비동기 콜백 내부에서도 `await`가 안전하게 동작하도록 `Task.detached`를 사용합니다.
    ///
    /// - Parameters:
    ///   - provider: MoyaProvider 인스턴스
    ///   - target: Moya TargetType (API 정보)
    ///   - retry: 401 발생 시 토큰 재발급 후 재시도할지 여부 (기본값 `true`)
    /// - Returns: 성공 시 디코딩된 타입을 `.success`, 실패 시 `NetworkError`를 `.failure`로 반환합니다.
    ///
    func requestDecodable<T: Decodable, Target: BaseTargetType>(
        _ provider: MoyaProvider<Target>,
        _ target: Target,
        retry: Bool = true) async -> Result<T, NetworkError> {
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
                    case 401 where retry:
                        RefreshTask.detached {
                            let refreshResult = await TokenRefresher.shared.refresh()
                            
                            switch refreshResult {
                            case .success:
                                Self.logger.info("Token refreshed, retrying request")
                                let retryResult: Result<T, NetworkError> = await self.requestDecodable(provider, target, retry: false)
                                continuation.resume(returning: retryResult)
                                
                            case .failure:
                                Self.logger.error("Token refresh failed")
                                continuation.resume(returning: .failure(.unauthorized))
                            }
                        }
                        
                    case 401:
                        continuation.resume(returning: .failure(.unauthorized))
                    case 403:
                        if let errorResponse = try? JSONDecoder().decode(ErrorResponseDTO.self, from: response.data),
                           errorResponse.message.contains("신고 처리된 계정") {
                            continuation.resume(returning: .failure(.reportedUser))
                        } else {
                            continuation.resume(returning: .failure(.forbidden))
                        }
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
    
    /// 네트워크 요청을 수행하고 별도의 응답 데이터 없이 성공 여부만 판단합니다.
    ///
    ///    - HTTP 200~299 상태 코드는 `.success(())`로 반환합니다.
    ///    - HTTP 401 Unauthorized + `retry == true`인 경우,
    ///      `RefreshTask`를 사용해 비동기로 토큰을 재발급(`TokenRefresher.shared.refresh()`)하고
    ///      성공 시 동일한 요청을 `retry: false`로 재시도합니다.
    ///    - 비동기 콜백 내부에서도 `await`가 안전하게 동작하도록 `Task.detached`를 사용합니다.
    ///
    /// - Parameters:
    ///   - provider: MoyaProvider 인스턴스
    ///   - target: Moya TargetType (API 정보)
    ///   - retry: 401 발생 시 토큰 재발급 후 재시도할지 여부 (기본값 `true`)
    /// - Returns: 성공 시 `.success(())`, 실패 시 `NetworkError`를 `.failure`로 반환합니다.
    ///
    func requestVoid<Target: BaseTargetType>(
        _ provider: MoyaProvider<Target>,
        _ target: Target,
        retry: Bool = true
    ) async -> Result<Void, NetworkError> {
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
                        if let apiError = try? JSONDecoder()
                            .decode(ErrorResponseDTO.self, from: response.data) {
                            continuation.resume(returning: .failure(.apiError(message: apiError.message)))
                        } else {
                            continuation.resume(returning: .failure(.badRequest))
                        }
                    case 401 where retry:
                        RefreshTask.detached {
                            let refreshResult = await TokenRefresher.shared.refresh()
                            
                            switch refreshResult {
                            case .success:
                                Self.logger.info("Token refreshed, retrying request")
                                let retryResult: Result<Void, NetworkError> = await self.requestVoid(provider, target, retry: false)
                                continuation.resume(returning: retryResult)
                                
                            case .failure:
                                Self.logger.error("Token refresh failed")
                                continuation.resume(returning: .failure(.unauthorized))
                            }
                        }
                        
                    case 401:
                        continuation.resume(returning: .failure(.unauthorized)) 
                    case 404:
                        continuation.resume(returning: .failure(.notFound))
                    case 409:
                        if let apiError = try? JSONDecoder()
                            .decode(ErrorResponseDTO.self, from: response.data) {
                            continuation.resume(returning: .failure(.apiError(message: apiError.message)))
                        } else {
                            continuation.resume(returning: .failure(.badRequest))
                        }
                    case 500...599:
                        continuation.resume(returning: .failure(.internalServerError))
                    default:
                        continuation.resume(returning: .failure(.networkFail))
                    }
                case .failure:
                    Self.logger.error("Network error")
                    continuation.resume(returning: .failure(.networkFail))
                }
            }
        }
    }
}
