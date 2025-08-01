//
//  NavigationRouter.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/7/25.
//

import SwiftUI

enum Route: Hashable {
    case settingView
    case withDrawSelectReasonView
    case withDrawWriteReasonView
    case withDrawConfirmView
    case searchInputView
    case marketView(storeId: Int)
    case profileEditView
    case genreDetailView(genreId: Int, genreName: String)
    case productDetailView(productId: Int)
    case searchView(searchWord: String)
    case reportView(reportType: ReportType, id: Int)
    case chatDetailView(chatEntry: ChatEntry)
    case likeView
}

final class NavigationRouter: ObservableObject {
    
    //MARK: - Property Wrappers
    
    @Published var path = NavigationPath()
    
    //MARK: - Method
    
    //다음에 보여질 view를 navigationStack에 push
    func push(next route: Route) {
        path.append(route)
    }
    
    //현재 view를 navigationStack에서 pop
    func pop() {
        path.removeLast()
    }
    
    //맨 처음으로 돌아감(navigationStack 초기화)
    func reset() {
        path = NavigationPath()
    }
}
