//
//  TabRouter.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/11/25.
//

import SwiftUI

class TabRouter: ObservableObject {
    @Published var selectedTab: NZTab = .home
    
    func switchToSearch() {
        selectedTab = .search
    }
    
    func switchToHome() {
        selectedTab = .home
    }
    
    func switchToChat() {
        selectedTab = .chat
    }
    
    func switchToMy() {
        selectedTab = .my
    }
}
