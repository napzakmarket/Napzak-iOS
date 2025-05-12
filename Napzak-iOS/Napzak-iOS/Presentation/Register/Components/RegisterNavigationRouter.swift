//
//  RegisterNavigationRouter.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 5/12/25.
//

import SwiftUI

enum RegisterRoute: Hashable {
    case registerSearchGenre
}

final class RegisterNavigationRouter: ObservableObject {
    
    //MARK: - Property Wrappers
    
    @Published var path = NavigationPath()
    
    //MARK: - Method
    
    //다음에 보여질 view를 navigationStack에 push
    func push(next route: RegisterRoute) {
        path.append(route)
    }
    
    //현재 view를 navigationStack에서 pop
    func pop() {
        path.removeLast()
    }
}

