//
//  LoadingViewManager.swift
//  Napzak-iOS
//
//  Created by OneTen on 6/27/25.
//

import SwiftUI

final class LoadingViewManager: ObservableObject {
    @Published var isLoadingNetwork: Bool = false
    
    private var loadingCount = 0 {
        didSet {
            self.isLoadingNetwork = self.loadingCount > 0
        }
    }

    func startLoading() {
        loadingCount += 1
    }

    func stopLoading() {
        loadingCount = max(loadingCount - 1, 0)
    }
}
