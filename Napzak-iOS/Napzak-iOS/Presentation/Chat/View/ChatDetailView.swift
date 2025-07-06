//
//  ChatDetailView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 6/29/25.
//

import SwiftUI

import Kingfisher

struct ChatDetailView: View {
    
    //MARK: - Property Wrappers
    
    @EnvironmentObject private var navigationRouter: NavigationRouter
    
    @StateObject var viewModel: ChatDetailViewModel
    
    @FocusState private var isFocused: Bool

    @State private var isSent = true
    @State private var tempID = 10

    //MARK: - Properties
        
    private let maxPrice: Int = 1_000_000
    
    //MARK: - Main Body
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                VStack {
                    navigationBar
                    chatSection
                }
                
                VStack {
                    productInfo
                    Spacer()
                    chatInputSection
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .contentShape(Rectangle())
        }
        .ignoresSafeArea(edges: [.top])
        .toolbar(.hidden, for: .navigationBar)
        .onTapGesture {
            isFocused = false
        }
    }
}

extension ChatDetailView {
    
    //MARK: - UI Properties
    
    private var navigationBar: some View {
        VStack {
            Spacer()
            HStack(alignment: .center) {
                Button {
                    navigationRouter.pop()
                } label: {
                    Image(.iconBack)
                        .frame(width: 48, height: 48)
                }
                Spacer()
                Text(viewModel.chatDetailInfo.chatStoreInfo.nickname)
                    .applyNapzakFont(.body1Bold16)
                    .foregroundStyle(Color.napzakGrayScale(.black))
                Spacer()
                Button {
                    //TODO: - 모달 띄우기
                    
                } label: {
                    Image(.iconMoreOptions)
                        .frame(width: 48, height: 48)
                }
            }
        }
        .frame(height: 100)
    }
    
    private var productInfo: some View {
        HStack(alignment: .center, spacing: 12) {
            Group {
                if let url = URL(string: viewModel.chatDetailInfo.productInfo.photo) {
                    KFImage(url)
                        .placeholder {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.napzakGrayScale(.gray100))
                        }
                        .retry(maxCount: 3, interval: .seconds(5))
                        .onFailure { error in
                            print("failure: \(error.localizedDescription)")
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.napzakGrayScale(.gray100))
                }
            }
            .frame(width: 70, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center, spacing: 8) {
                    Image(viewModel.chatDetailInfo.productInfo.tradeType == .sell ? .imgChatSellTag : .imgChatBuyTag)
                    if viewModel.chatDetailInfo.productInfo.isPriceNegotiable {
                        Image(.imgChatBiddingTag)
                    }
                }
                .padding(.bottom, 5)

                Text(viewModel.chatDetailInfo.productInfo.title)
                    .applyNapzakFont(.body5SemiBold14)
                    .foregroundStyle(Color.napzakGrayScale(.black))
                    .frame(height: 18)
                Text(viewModel.chatDetailInfo.productInfo.price.convertPriceByTradeType(
                    tradeType: viewModel.chatDetailInfo.productInfo.tradeType)
                )
                .applyNapzakFont(.body2SemiBold16)
                .foregroundStyle(Color.napzakGrayScale(.black))
                .frame(height: 20)
            }
            Spacer()
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 20)
        .background(
            Color.napzakGrayScale(.white)
                .shadow(color: .black.opacity(0.1), radius: 2)
        )
        .padding(.top, 100)
    }
    
    private var chatSection: some View {
        Group {
            if viewModel.chatMessages.isEmpty {
                emptyView
            } else {
                chatMessagesView
            }
        }
    }
    
    private var emptyView: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            Image(.imgChatDetailEmpty)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 13)
            Text("채팅을 시작해보세요!")
                .applyNapzakFont(.body2SemiBold16)
                .foregroundStyle(Color.napzakGrayScale(.gray300))
            Text("안전한 거래를 위해 먼저 이야기를 나눠보세요")
                .applyNapzakFont(.body5SemiBold14)
                .foregroundStyle(Color.napzakGrayScale(.gray200))
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.keyboard)
    }
    
    private var chatMessagesView: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                Color.clear
                    .frame(height: 0)
                    .id("lastChat")

                LazyVStack(spacing: 8) {
                    ForEach(viewModel.chatMessages) { data in
                        ChatBody(
                            chatData: data,
                            storeImage: viewModel.chatDetailInfo.chatStoreInfo.storePhoto
                        )
                        .padding(.horizontal, 15)
                    }
                }
                .rotationEffect(Angle(degrees: 180))
                .scaleEffect(x: -1.0, y: 1.0 , anchor: .center)
                .padding(.vertical, 10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .rotationEffect(Angle(degrees: 180))
            .scaleEffect(x: -1.0, y: 1.0 , anchor: .center)
            .padding(.top, 90)
            .padding(.bottom, 60)
            .onChange(of: isSent) { _ in
                proxy.scrollTo("lastChat", anchor: .top)
            }
        }
    }
    
    private var chatInputSection: some View {
        HStack(alignment: .center, spacing: 12) {
            Button {
                //TODO: - 사진 앱에서 선택하도록 연결
                
                //서버 연결 이후 삭제 예정. UI 확인용!
                viewModel.chatMessages.append(ChatMessageModel(
                    id: tempID,
                    senderId: 1,
                    type: .image,
                    content: nil,
                    metaData: .image(
                        ImageMeta(
                            type: .image,
                            imageUrls: ["https://i.pinimg.com/736x/86/e8/c9/86e8c92b974b7d21a84a2af1b2650143.jpg"]
                        )
                    ),
                    createdAt: "오전 7:30",
                    isFirstChat: !isSent,
                    isMessageOwner: isSent,
                    isRead: true
                ))
                isSent.toggle()
                tempID += 1
            } label: {
                Image(.iconGallary)
            }
            ChatMessageInputBar (
                text: $viewModel.messageText,
                isFocused: _isFocused,
                isChatDisabled: viewModel.chatDetailInfo.chatStoreInfo.isWithdrawn,
                onSubmit: {
                    
                    //서버 연결 이후 삭제 예정. UI 확인용!
                    switch viewModel.messageText {
                    case "날짜":
                        viewModel.chatMessages.append(ChatMessageModel(
                            id: tempID,
                            senderId: 3,
                            type: .date,
                            content: nil,
                            metaData: .date(
                                DateMeta(type: .date, date: "2025년 4월 30일")
                            ),
                            createdAt: "오전 7:30",
                            isFirstChat: !isSent,
                            isMessageOwner: isSent,
                            isRead: true
                        ))
                    case "상품":
                        viewModel.chatMessages.append(ChatMessageModel(
                            id: tempID,
                            senderId: 2,
                            type: .product,
                            content: nil,
                            metaData: .product(
                                ProductMeta(
                                    type: .product,
                                    tradeType: viewModel.chatDetailInfo.productInfo.tradeType,
                                    productId: 0,
                                    genreName: viewModel.chatDetailInfo.productInfo.genreName,
                                    title: viewModel.chatDetailInfo.productInfo.title,
                                    price: viewModel.chatDetailInfo.productInfo.price
                                )
                            ),
                            createdAt: "오전 7:30",
                            isFirstChat: !isSent,
                            isMessageOwner: isSent,
                            isRead: true
                        ))
                        tempID += 1
                        viewModel.chatMessages.append(ChatMessageModel(
                            id: tempID,
                            senderId: 0,
                            type: .text,
                            content: "거래합시다",
                            metaData: nil,
                            createdAt: "오전 7:30",
                            isFirstChat: !isSent,
                            isMessageOwner: isSent,
                            isRead: false
                        ))
                    case "나감":
                        viewModel.chatMessages.append(ChatMessageModel(
                            id: tempID,
                            senderId: 4,
                            type: .system,
                            content: nil,
                            metaData: .system(
                                SystemMeta(
                                    type: .leave,
                                    content: ""
                                )
                            ),
                            createdAt: "오전 7:30",
                            isFirstChat: !isSent,
                            isMessageOwner: isSent,
                            isRead: true
                        ))
                    case "신고":
                        viewModel.chatMessages.append(ChatMessageModel(
                            id: tempID,
                            senderId: 4,
                            type: .system,
                            content: nil,
                            metaData: .system(
                                SystemMeta(
                                    type: .reported,
                                    content: ""
                                )
                            ),
                            createdAt: "오전 7:30",
                            isFirstChat: !isSent,
                            isMessageOwner: isSent,
                            isRead: true
                        ))
                    default:
                        viewModel.chatMessages.append(ChatMessageModel(
                            id: tempID,
                            senderId: 0,
                            type: .text,
                            content: viewModel.messageText,
                            metaData: nil,
                            createdAt: "오전 7:30",
                            isFirstChat: !isSent,
                            isMessageOwner: isSent,
                            isRead: false
                        ))
                    }
                    isSent.toggle()
                    tempID += 1
                }
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(
            Color.napzakGrayScale(.white)
                .shadow(color: .black.opacity(0.1), radius: 2)
        )
        .padding(.top, 10)
        .clipped()
    }
}
