//
//  TabRouter.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/11/25.
//

import SwiftUI

struct SearchParams {
    var searchWord: String
    var sortOption: SortOption
    var selectedTab: Int
}

class TabRouter: ObservableObject {
    @Published var selectedTab: NZTab = .home
    @Published var searchParams: SearchParams = SearchParams(
        searchWord: "",
        sortOption: .recent,
        selectedTab: 0
    )
    @Published var showChatRoomExitToast = false
    
    var currentSearchWord: String {
        return searchParams.searchWord
    }
    
    var currentSortOption: SortOption {
        return searchParams.sortOption
    }
    
    var currentSelectedTab: Int {
        return searchParams.selectedTab
    }
    
    func switchToSearch(searchWord: String, sortOption: SortOption, searchTabIndex: Int) -> Void {
        searchParams.searchWord = searchWord
        searchParams.sortOption = sortOption
        searchParams.selectedTab = searchTabIndex
        
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
