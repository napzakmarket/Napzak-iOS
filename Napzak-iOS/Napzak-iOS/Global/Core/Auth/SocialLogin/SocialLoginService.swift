//
//  SocialLoginService.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/1/25.
//

import Foundation

protocol SocialLoginService {
    func login() async -> Result<String, AuthError>
    func logout() async -> Result<Void, AuthError>
    func getServiceName() -> String
}
