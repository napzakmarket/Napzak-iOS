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
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var viewModel: ChatDetailViewModel
    @StateObject private var chatImagePickerManager = ImagePickerManager()
    
    @FocusState private var isFocused: Bool

    @State private var isSent = true
    @State private var tempID = 10
    @State private var isViewerOptionsPresented = false
    @State private var isExitAlertPresented = false

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
                
                if isViewerOptionsPresented {
                    Color.napzakTransparency(.transBlack)
                        .onTapGesture {
                            withAnimation {
                                isViewerOptionsPresented = false
                            }
                        }
                        .transition(.opacity)
                        .zIndex(1)
                    
                    VStack {
                        Spacer()
                        ReportModalView(
                            isReportModalPresented: $isViewerOptionsPresented,
                            reportType: .store,
                            isUsedInChat: true,
                            onReportButtonTapped: { },
                            onExitButtonTapped: {
                                isExitAlertPresented = true
                            }
                        )
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(2)
                }
                
                if isExitAlertPresented {
                    ZStack(alignment: .center) {
                        Color.napzakTransparency(.transBlack)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    isExitAlertPresented = false
                                }
                            }
                            .transition(.opacity)
                            .zIndex(1)

                        NZAlertView(
                            style: .plain,
                            titleMessage: "채팅방 나가기",
                            subTitleMessage: "채팅방에서 나가시겠어요? 나가기를 하면\n더이상 상대방과 대화할 수 없습니다.",
                            confirmText: "나가기",
                            cancelText: "취소",
                            onConfirm: {
                                Task {
                                    await viewModel.exitChatRoom()
                                }
                                isExitAlertPresented = false
                                navigationRouter.pop()
                            },
                            onCancel: {
                                isExitAlertPresented = false
                            }
                        )
                        .zIndex(2)
                    }
                    .zIndex(3)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .contentShape(Rectangle())
        }
        .ignoresSafeArea(edges: [.top])
        .toolbar(.hidden, for: .navigationBar)
        .animation(.easeInOut(duration: 0.3), value: isViewerOptionsPresented)
        .animation(.easeInOut(duration: 0.3), value: isExitAlertPresented)
        .onTapGesture {
            isFocused = false
        }
        .onChange(of: chatImagePickerManager.selectedImages) { images in
            if let firstImage = images.first {
                viewModel.selectedImage = firstImage
                Task {
                    await viewModel.uploadImage()
                }
                chatImagePickerManager.selectedImages = []
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive {
                Task {
                    await viewModel.leaveChatRoom()
                }
            } else if phase == .active {
                if let roomId = viewModel.roomId {
                    Task {
                        await viewModel.enterChatRoom(roomId: roomId)
                        await viewModel.fetchChatMessages(roomId: roomId)
                    }
                }
            }
        }
        .onAppear {
            chatImagePickerManager.setOverrideMaxCount(1)
        }
        .onDisappear {
            Task {
                await viewModel.leaveChatRoom()
            }
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
                    isViewerOptionsPresented = true
                } label: {
                    Image(.iconMoreOptions)
                        .frame(width: 48, height: 48)
                }
            }
        }
        .frame(height: 100)
        .padding(.horizontal, 9)
    }
    
    private var productInfo: some View {
        Button {
            navigationRouter.push(next: .productDetailView(productId: viewModel.chatDetailInfo.productInfo.productId))
        } label: {
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
                .padding(.vertical, 10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .rotationEffect(Angle(degrees: 180))
            .padding(.top, 90)
            .padding(.bottom, 60)
            .onChange(of: isSent) { _ in
                proxy.scrollTo("lastChat", anchor: .top)
            }
        }
    }
    
    private var chatInputSection: some View {
        HStack(alignment: .center, spacing: 12) {
            chatImagePickerManager.photoPickerView(maxCount: 1) {
                Image(.iconGallary)
            }
            .disabled(viewModel.isChatDisabled)
            
            ChatMessageInputBar (
                text: $viewModel.messageText,
                isFocused: _isFocused,
                isChatDisabled: viewModel.isChatDisabled,
                onSubmit: {
                    let messageText = viewModel.messageText
                    
                    if viewModel.chatMessages.isEmpty && viewModel.roomId == nil {
                        Task {
                            await viewModel.postChatRoomCreate()
                            viewModel.sendFirstMessage(firstMessageText: messageText)
                        }
                    } else if viewModel.shouldUpdateProductInfo {
                        viewModel.sendProductUpdateMessage(messageText: messageText)
                    } else {
                        Task {
                            await viewModel.sendTextMessage(text: messageText)
                        }
                    }
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
