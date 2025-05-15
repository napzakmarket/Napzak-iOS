//
//  TabRouter.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/11/25.
//

import SwiftUI

class TabRouter: ObservableObject {
    @Published var selectedTab: NZTab = .home
    @Published var searchParams: (sortOption: SortOption, selectedTab: Int)?
    
    var currentSortOption: SortOption {
        return searchParams?.sortOption ?? .recent
    }
    
    var currentSelectedTab: Int {
        return searchParams?.selectedTab ?? 0
    }
    
    func switchToSearch(sortOption: SortOption? = nil, searchTabIndex: Int? = nil) -> Void {
        selectedTab = .search
        
        if let sortOption = sortOption {
            searchParams = (sortOption: sortOption, selectedTab: searchTabIndex ?? 0)
        } else if searchParams == nil {
            searchParams = (sortOption: .recent, selectedTab: 0)
        }
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
