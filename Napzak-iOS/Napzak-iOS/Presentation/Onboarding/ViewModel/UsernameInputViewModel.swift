//
//  UsernameInputViewModel.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/8/25.
//

import Foundation
import os

@MainActor
final class UsernameInputViewModel: ObservableObject {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "UsernameValidation")
    
    @Published var validationState: UsernameValidation = .empty
    @Published var isPrimaryButtonEnabled: Bool = false
    @Published var username: String = ""
    private var isRequesting: Bool = false
    
    private let service = NetworkService.shared.storeService
    
    func validateUsername(_ username: String) async {
        isRequesting = true
        let request = NicknameRequestDTO(nickname: username)
        let result = await service.validateNickname(request: request)
        isRequesting = false
        
        switch result {
        case .success:
            validationState = .valid
            isPrimaryButtonEnabled = true
            
        case .failure(let error):
            validationState = .serverError(error.errorDescription ?? "")
            isPrimaryButtonEnabled = false
        }
    }
    
}
