//
//  MoyaPlugin.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/28/25.
//

import Foundation

import Moya
import os

final class MoyaPlugin: PluginType {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "Network")
    
    // MARK: - Request
    func willSend(_ request: RequestType, target: TargetType) {
        guard let httpRequest = request.request else {
            Self.logger.error("❌ Invalid Request")
            return
        }
        
        let url = httpRequest.description
        let method = httpRequest.httpMethod ?? "unknown method"
        
        Self.logger.info("📡 [\(method)] \(url)")
        Self.logger.debug("API: \(target.path)")
        
        if let headers = httpRequest.allHTTPHeaderFields, !headers.isEmpty {
            Self.logger.debug("Headers: \(String(describing: headers), privacy: .sensitive)")
        }
        
        if let body = httpRequest.httpBody,
           let bodyString = String(bytes: body, encoding: .utf8) {
            Self.logger.debug("Body: \(bodyString)")
        }
    }

    // MARK: - Response
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case let .success(response):
            self.onSucceed(response)
        case let .failure(error):
            self.onFail(error)
        }
    }

    private func onSucceed(_ response: Response) {
        let request = response.request
        let url = request?.url?.absoluteString ?? "nil"
        let statusCode = response.statusCode
        
        Self.logger.info("✅ [\(statusCode)] \(url)")
        
        if let json = try? JSONSerialization.jsonObject(with: response.data, options: .mutableContainers),
           let prettyJsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let prettyString = String(data: prettyJsonData, encoding: .utf8) {
            Self.logger.debug("Response: \(prettyString)")
        } else if let plainString = String(bytes: response.data, encoding: .utf8) {
            Self.logger.debug("Response: \(plainString)")
        }
    }

    private func onFail(_ error: MoyaError) {
        if let response = error.response {
            onSucceed(response)
            return
        }
        
        Self.logger.error("❌ Network Error: \(error.errorCode)")
        if let reason = error.failureReason {
            Self.logger.error("Reason: \(reason)")
        }
    }
}
