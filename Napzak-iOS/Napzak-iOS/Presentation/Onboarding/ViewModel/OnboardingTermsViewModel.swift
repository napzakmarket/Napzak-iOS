//
//  OnboardingTermsViewModel.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/8/25.
//

import SwiftUI

@MainActor
class OnboardingTermsViewModel: ObservableObject {
    @Published var termsUrl: String = ""
    @Published var privacyUrl: String = ""
    
    private let storeService = NetworkService.shared.storeService
    
    func fetchTermsUrls() async {
        let result = await storeService.getTerms()
        switch result {
        case .success(let response):
            guard let termList = response.data?.termList else { return }
            
            let termsUrl = termList[0].termsUrl
            let privacyUrl = termList[1].termsUrl
            
            self.termsUrl = termsUrl
            self.privacyUrl = privacyUrl
        case .failure(let error):
            print("Error fetching terms: \(error)")
        }
    }
    
    func openUrl(_ urlString: String) {
        guard let url = URL(string: urlString),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}
