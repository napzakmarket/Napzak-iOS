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
                .ignoresSafeArea(.keyboard)
                
                VStack {
                    productInfo
                    Spacer()
                    chatInputSection
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea(edges: [.top])
        .toolbar(.hidden, for: .navigationBar)
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
    }
    
    private var chatMessagesView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 8) {
                ForEach(viewModel.chatMessages) { data in
                    ChatBody(
                        chatData: data,
                        storeImage: viewModel.chatDetailInfo.chatStoreInfo.storePhoto
                    )
                        .padding(.horizontal, 15)
                }
            }
            .padding(.vertical, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 90)
        .padding(.bottom, 60)
    }
    
    private var chatInputSection: some View {
        HStack(alignment: .center, spacing: 12) {
            Button {
                //TODO: - 사진 앱에서 선택하도록 연결
            } label: {
                Image(.iconGallary)
            }
            ChatMessageInputBar (
                text: $viewModel.messageText,
                isChatDisabled: viewModel.chatDetailInfo.chatStoreInfo.isWithdrawn,
                onSubmit: { }
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
