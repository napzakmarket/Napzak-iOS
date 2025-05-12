//
//  NavigationRouter.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/7/25.
//

import SwiftUI

enum Route: Hashable {
    //임시 뷰
    case sView
    case mView
    case SettingView
    case searchInputView
    case MarketView
    case ProfileEditView
    case genreDetailView(genreId: Int, genreName: String)
    case productDetailView(productId: Int)
    
    // 등록 뷰 내부 사용
    case registerSearchGenre
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
