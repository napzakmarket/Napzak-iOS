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
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "WithDrawView")

    
    
    
}
