//
//  ChatView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 6/23/25.
//

import SwiftUI

struct ChatView: View {
    
    //MARK: - Property Wrappers
    
    @EnvironmentObject private var navigationRouter: NavigationRouter
    
    //MARK: - Main Body
    
    var body: some View {
        VStack {
            Button {
                navigationRouter.push(next: .chatView)
            } label: {
                Text("채팅")
                    .applyNapzakFont(.title1Bold22)
            }
        }
    }
}
