//
//  WithDrawViewModel.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/12/25.
//

import SwiftUI
import os

final class WithDrawViewModel: ObservableObject {
    
    static let shared = WithDrawViewModel()
    
    private let keychain = KeychainManager.shared
    
    private init() { }
    
    @Published var withdrawReasonTitle: String = "원하는 굿즈를 찾기 어려워요"
    @Published var withDrawReasons: [String] = [
        WithdrawReasonMessage.hardToFindGoods,
        WithdrawReasonMessage.poorSales,
        WithdrawReasonMessage.inconvenientApp,
        WithdrawReasonMessage.encounteredRudeUser,
        WithdrawReasonMessage.wantNewAccount,
        WithdrawReasonMessage.privacyConcerns,
        WithdrawReasonMessage.noLongerInterested,
        WithdrawReasonMessage.other
    ]
    
    @Published var withdrawDescription: String = ""
    @Published var withdrawDescriptionNull: Bool = false
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "WithDrawView")
}


// MARK: - Network

extension WithDrawViewModel {
    func withdraw() async {
        let dto = WithDrawRequestDTO(
            withdrawTitle: withdrawReasonTitle,
            withdrawDescription: withdrawDescriptionNull ? nil : withdrawDescription
        )
        
        let result = await NetworkService.shared.authService.withDraw(item: dto)
        
        switch result {
        case .success(let response):
            logger.info("✅ 탈퇴 성공: \(response.message)")
            logger.info("✅ 탈퇴한 ID: \(response.data!.storeId)")
            logger.info("✅ 탈퇴 사유: \(response.data!.withdrawTitle)")
            logger.info("✅ 탈퇴 설명: \(response.data!.withdrawDescription ?? "없음")")
            
            await AuthManager.shared.forceLogout()
            if case .failure(let error) = keychain.clearTokens() {
                logger.error("❌ 토큰 삭제 실패: \(error)")
            }
        case .failure(let error):
            logger.error("❌ 탈퇴 실패: \(error.localizedDescription)")
        }
    }
    
    func resetWithdraw() {
        withdrawReasonTitle = "원하는 굿즈를 찾기 어려워요"
        withdrawDescription = ""
        withdrawDescriptionNull = false
    }
}
