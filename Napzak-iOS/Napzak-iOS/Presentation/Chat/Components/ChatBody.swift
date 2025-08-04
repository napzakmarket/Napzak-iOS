//
//  ChatBody.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 6/30/25.
//

import SwiftUI

import Kingfisher

struct ChatBody: View {
    
    //MARK: - Property Wrappers
    
    @EnvironmentObject private var navigationRouter: NavigationRouter
    
    @State private var isImageDetailViewPresent: Bool = false
    @State private var imageUrl = ""
    
    //MARK: - Properties
    
    let chatData: ChatMessageModel
    let storeImage: String
    
    let screenWidth = UIScreen.main.bounds.width

    //MARK: - Main Body
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            switch chatData.type {
            case .text, .image, .product:
                if chatData.isMessageOwner {
                    Spacer()
                    timeLabel
                }
            default:
                EmptyView()
            }
            
            switch chatData.type {
            case .text:
                HStack(alignment: .top, spacing: 0) {
                    if chatData.isProfileNeeded && !chatData.isMessageOwner {
                        profileImage
                    }
                    ChatBubble(
                        message: chatData.content ?? "",
                        isMessageOwner: chatData.isMessageOwner
                    )
                    .padding(.top, chatData.isProfileNeeded ? 20 : 0)
                    .padding(.leading, !chatData.isProfileNeeded && !chatData.isMessageOwner ? 44 : 0)
                }
            case .image:
                if case let .image(image) = chatData.metadata {
                    HStack(alignment: .top, spacing: 0) {
                        if chatData.isProfileNeeded && !chatData.isMessageOwner {
                            profileImage
                        }
                        ChatImageMessage(
                            imageUrl: image.imageUrls[0],
                            onZoomButtonTapped: {
                                isImageDetailViewPresent = true
                            }
                        )
                        .padding(.top, chatData.isProfileNeeded ? 20 : 0)
                        .padding(.leading, !chatData.isProfileNeeded && !chatData.isMessageOwner ? 44 : 0)
                    }
                    .fullScreenCover(isPresented: $isImageDetailViewPresent) {
                        ImageDetailView(
                            isImageDetailViewPresent: $isImageDetailViewPresent,
                            imageUrl: image.imageUrls[0]
                        )
                    }
               }
            case .product:
                if case let .product(product) = chatData.metadata {
                    ChatStarter(
                        product: product,
                        isMessageOwner: chatData.isMessageOwner,
                        onProductButtonTapped: {
                            navigationRouter.push(next: .productDetailView(productId: product.productId))
                        }
                    )
                    .frame(width: screenWidth - 140)
                }
            case .system:
                if case let .system(system) = chatData.metadata {
                    switch system.type {
                    case .exit:
                        userLeavingDivider
                            .padding(.vertical, 17)
                    case .reported:
                        Image(.imgUserBlocked)
                            .padding(.vertical, 20)
                    case .withdrawn:
                        EmptyView()
                    }
                }
            case .date:
                if case let .date(date) = chatData.metadata {
                    ChatDateDivider(date: date.date)
                }
            }
            
            switch chatData.type {
            case .text, .image, .product:
                if !chatData.isMessageOwner {
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
            if chatData.isMessageOwner && !(chatData.isRead ?? false) {
                Text("1")
                    .applyNapzakFont(.caption5Regular10)
                    .foregroundStyle(Color.napzakGrayScale(.gray200))
            }
            Text(chatData.createdAt ?? "")
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
