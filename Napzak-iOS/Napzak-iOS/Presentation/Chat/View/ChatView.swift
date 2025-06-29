//
//  ChatView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 6/23/25.
//

import SwiftUI

import Kingfisher

struct ChatView: View {
    
    //MARK: - Property Wrappers
    
    @EnvironmentObject private var navigationRouter: NavigationRouter
    
    //MARK: - Properties
    
    let imageURL: String?
    
    //MARK: - Main Body
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                navigationBar
                chatSection
            }
            productInfo
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: [.top])
        .toolbar(.hidden, for: .navigationBar)
    }
}

extension ChatView {
    
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
                Text("마이린")
                    .applyNapzakFont(.body1Bold16)
                    .foregroundStyle(Color.napzakGrayScale(.black))
                Spacer()
                Button {
                    
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
                if let imageURL = imageURL, let url = URL(string: imageURL) {
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
            VStack(alignment: .leading, spacing: 0) {
                Image(.imgChatSellTag)
                    .padding(.bottom, 5)
                Text("은혼 긴토키 히지카타 룩업")
                    .applyNapzakFont(.body5SemiBold14)
                    .foregroundStyle(Color.napzakGrayScale(.black))
                    .frame(height: 18)
                Text("125,000원")
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
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            Image(.imgChatEmpty)
                .padding(.trailing, 30)
                .padding(.bottom, 15)
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
}
