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
    @Environment(\.scenePhase) var scenePhase

    @StateObject var viewModel: ChatViewModel
    
    //MARK: - Init
    
    init() {
        self._viewModel = StateObject(wrappedValue: ChatViewModel())
    }
    
    //MARK: - Main Body
    
    var body: some View {
        ZStack {
            chatListSection
            
            VStack {
                navigationBar
                Spacer()
            }
        }
        .ignoresSafeArea(edges: [.vertical])
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                Task {
                    await viewModel.fetchChatRooms()
                }
            }
        }
    }
}

extension ChatView {
    
    //MARK: - UI Properties
    
    private var navigationBar: some View {
        VStack {
            Spacer()
            HStack {
                Text("채팅")
                    .applyNapzakFont(.body2SemiBold16)
                    .foregroundStyle(Color.napzakGrayScale(.gray400))
                    .padding([.leading, .bottom], 20)
                Spacer()
            }
        }
        .frame(height: 100)
        .frame(maxWidth: .infinity)
        .background(
            Color.napzakGrayScale(.white)
                .shadow(color: .black.opacity(0.1), radius: 2)
        )
    }
    
    private var chatListSection: some View {
        Group {
            if viewModel.chatRooms.isEmpty {
                emptyView
            } else {
                chatRoomsView
            }
        }
    }
    
    private var emptyView: some View {
        VStack(alignment: .center, spacing: 6) {
            Spacer()
            Image(.imgChatEmpty)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 10)
            Text("아직 시작된 대화가 없어요")
                .applyNapzakFont(.body2SemiBold16)
                .foregroundStyle(Color.napzakGrayScale(.gray300))
            Text("관심 있는 아이템이 있다면 대화를 시작해보세요")
                .applyNapzakFont(.caption1SemiBold12)
                .foregroundStyle(Color.napzakGrayScale(.gray200))
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.keyboard)
    }
    
    private var chatRoomsView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.chatRooms) { data in
                    Button {
                        navigationRouter.push(next: .chatDetailView(chatEntry: .room(id: data.id)))
                    } label: {
                        ChatItemView(chatRoom: data)
                    }
                }
            }
            .padding(.top, 125)
            .padding(.bottom, 115)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
