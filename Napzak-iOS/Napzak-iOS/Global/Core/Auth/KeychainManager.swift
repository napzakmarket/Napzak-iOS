//
//  KeychainManager.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/1/25.
//

import Foundation

final class KeychainManager {
    static let shared = KeychainManager()
    
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    
    private init() {}

    // MARK: - Public Methods

    func saveTokens(access: String, refresh: String) -> Result<Void, AuthError> {
        switch save(key: accessTokenKey, value: access) {
        case .success:
            switch save(key: refreshTokenKey, value: refresh) {
            case .success:
                return .success(())
            case .failure(let error):
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    
    @discardableResult
    func updateAccessToken(_ token: String) -> Result<Void, AuthError> {
        return save(key: accessTokenKey, value: token)
    }
    
    @discardableResult
    func updateRefreshToken(_ token: String) -> Result<Void, AuthError> {
        return save(key: refreshTokenKey, value: token)
    }
    
    func getAccessToken() -> Result<String, AuthError> {
        return load(key: accessTokenKey)
    }

    func getRefreshToken() -> Result<String, AuthError> {
        return load(key: refreshTokenKey)
    }
    
    func clearTokens() -> Result<Void, AuthError> {
        switch delete(key: accessTokenKey) {
        case .success:
            switch delete(key: refreshTokenKey) {
            case .success:
                return .success(())
            case .failure(let error):
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }

    // MARK: - Private Methods

    private func save(key: String, value: String) -> Result<Void, AuthError> {
        let data = Data(value.utf8)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess ? .success(()) : .failure(.keychainError)
    }
    
    private func load(key: String) -> Result<String, AuthError> {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess,
           let data = result as? Data,
           let value = String(data: data, encoding: .utf8) {
            return .success(value)
        } else {
            return .failure(.tokenNotFound)
        }
    }

    private func delete(key: String) -> Result<Void, AuthError> {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return (status == errSecSuccess || status == errSecItemNotFound)
            ? .success(())
            : .failure(.keychainError)
    }
}
