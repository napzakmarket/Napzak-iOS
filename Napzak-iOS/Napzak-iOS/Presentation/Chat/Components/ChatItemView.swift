//
//  ChatItemView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 7/3/25.
//

import SwiftUI

import Kingfisher

struct ChatItemView: View {
        
    //MARK: - Properties
    
    let chatRoom: ChatRoomModel

    //MARK: - Main Body
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            profileImage
            VStack(alignment: .leading, spacing: 0) {
                Text(chatRoom.opponentNickname)
                    .applyNapzakFont(.body1Bold16)
                    .foregroundStyle(chatRoom.isOpponentWithdrawn ? Color.napzakGrayScale(.gray300) : Color.napzakPrimary(.purple500))
                Text(chatRoom.lastMessage)
                    .applyNapzakFont(.body6Regular14)
                    .foregroundStyle(Color.napzakGrayScale(.gray300))
                    .frame(height: 18)
            }
            .padding(.vertical, 20)
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                if chatRoom.unreadCount == 0 {
                    Spacer()
                } else {
                    Text(chatRoom.unreadCount > 999 ? "999+" : "\(chatRoom.unreadCount)")
                        .applyNapzakFont(.caption1SemiBold12)
                        .foregroundStyle(Color.napzakGrayScale(.white))
                        .frame(height: 15)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2.5)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.napzakState(.pink))
                        )
                }
                Text(chatRoom.lastMessageAt)
                    .applyNapzakFont(.caption3Regular12)
                    .foregroundStyle(Color.napzakGrayScale(.gray200))
            }
            .padding(.vertical, 20)
        }
        .padding(.horizontal, 20)
        .background(
            VStack {
                Color.napzakGrayScale(.gray50)
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                Spacer()
                Color.napzakGrayScale(.gray50)
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
            }
        )
    }
}

extension ChatItemView {
    
    //MARK: - UI Properties
    
    private var profileImage: some View {
        Group {
            if let url = URL(string: chatRoom.opponentStorePhoto) {
                KFImage(url)
                    .placeholder {
                        Circle()
                            .fill(Color.napzakGrayScale(.gray100))
                    }
                    .retry(maxCount: 3, interval: .seconds(5))
                    .onFailure { error in
                        print("failure: \(error.localizedDescription)")
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image(.imgChatProfileDefault)
                    .resizable()
            }
        }
        .frame(width: 52, height: 52)
        .clipShape(Circle())
        .padding(.vertical, 14)
    }
}

#Preview {
    struct PreviewContainer: View {
        var body: some View {
            ChatItemView(
                chatRoom: ChatRoomModel(
                    id: 0,
                    opponentNickname: "납자기",
                    isOpponentWithdrawn: false,
                    lastMessage: "사용자가 채팅방을 나갔습니다.",
                    lastMessageAt: "오전 1:38",
                    unreadCount: 8,
                    opponentStorePhoto: ""
                )
            )
        }
    }
    
    return PreviewContainer()
}
