//
//  ChatBody.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 6/30/25.
//

import SwiftUI

import Kingfisher

struct ChatBody: View {
    
    //MARK: - Properties
    
    let chatData: ChatMessageModel
    let storeImage: String
    
    //MARK: - Main Body
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            switch chatData.type {
            case .text, .image, .product:
                if !chatData.isReceived {
                    Spacer()
                    timeLabel
                }
            default:
                EmptyView()
            }
            
            switch chatData.type {
            case .text:
                HStack(alignment: .top, spacing: 0) {
                    if chatData.isFirstChat && chatData.isReceived {
                        profileImage
                    }
                    ChatBubble(
                        message: chatData.content ?? "",
                        isReceived: chatData.isReceived
                    )
                    .padding(.top, chatData.isFirstChat ? 20 : 0)
                }
            case .image:
                if case let .image(image) = chatData.metaData {
                    HStack(alignment: .top, spacing: 0) {
                        if chatData.isFirstChat && chatData.isReceived {
                            profileImage
                        }
                        ChatImageMessage(
                            imageUrl: image.imageUrls[0],
                            onZoomButtonTapped: { }
                        )
                        .padding(.top, chatData.isFirstChat ? 20 : 0)
                    }
                }
            case .product:
                if case let .product(product) = chatData.metaData {
                    ChatStarter(
                        product: product,
                        isReceived: chatData.isReceived,
                        onProductButtonTapped: { }
                    )
                }
            case .system:
                if case let .system(system) = chatData.metaData {
                    switch system.type {
                    case .leave:
                        userLeavingDivider
                    case .reported:
                        Image(.imgUserBlocked)
                    case .withdrawn:
                        EmptyView()
                    }
                }
            case .date:
                if case let .date(date) = chatData.metaData {
                    ChatDateDivider(date: date.date)
                }
            }
            
            switch chatData.type {
            case .text, .image, .product:
                if chatData.isReceived {
                    timeLabel
                    Spacer()
                }
            default:
                EmptyView()
            }
        }
    }
}

extension ChatBody {
    
    //MARK: - UI Properties
    
    private var profileImage: some View {
        Group {
            if let url = URL(string: storeImage) {
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
            }
        }
        .frame(width: 40, height: 40)
        .clipShape(Circle())
        .padding(.trailing, 4)
    }
    
    private var timeLabel: some View {
        VStack(alignment: .trailing, spacing: 0) {
            if !chatData.isReceived && !chatData.isRead {
                Text("1")
                    .applyNapzakFont(.caption5Regular10)
                    .foregroundStyle(Color.napzakGrayScale(.gray200))
            }
            Text(chatData.createdAt)
                .applyNapzakFont(.caption5Regular10)
                .foregroundStyle(Color.napzakGrayScale(.gray200))
        }
        .padding(.horizontal, 8)
    }
    
    private var userLeavingDivider: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(.imgChatDivider)
                .frame(maxWidth: .infinity)
            Text("상대방이 채팅방을 나갔습니다.")
                .frame(width: 144)
                .applyNapzakFont(.caption2Medium12)
                .foregroundStyle(Color.napzakGrayScale(.gray200))
            Image(.imgChatDivider)
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    struct PreviewContainer: View {
        let chatMessage = ChatMessageModel.mock
        
        var body: some View {
            ChatBody(
                chatData: chatMessage[2],
                storeImage: ""
            )
        }
    }
    
    return PreviewContainer()
        .padding(.horizontal, 20)
}
