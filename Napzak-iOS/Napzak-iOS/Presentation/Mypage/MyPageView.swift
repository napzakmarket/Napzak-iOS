//
//  MyPageView.swift
//  Napzak-iOS
//
//  Created by 어진 on 4/11/25.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject private var navigationRouter: NavigationRouter
    @State private var storeInfo: StoreProfileDTO?
    @State private var isLoading = true
    @State private var errorMessage: String?
        
    // StoreService 주입
    private let storeService: StoreServiceProtocol
    
    init(storeService: StoreServiceProtocol = StoreService()) {
        self.storeService = storeService
    }
    
    var body: some View {
        VStack(spacing: 0) {
            logoView
            
            if let storeInfo = storeInfo {
                // API 프로필 정보
                profileCardWithData(storeInfo: storeInfo)
            } else {
                // 스켈레톤
                profileCardPlaceholder
            }
            
            marketButton
            menuGrid

            Spacer()
            
            Rectangle()
                .fill(Color.napzakGrayScale(.gray10))
                .edgesIgnoringSafeArea(.bottom)
        }
        .background(Color.napzakGrayScale(.white))
        .onAppear {
            fetchMyPageInfo()
        }
    }
    
    private func fetchMyPageInfo() {
        isLoading = true
        
        Task {
            let result = await storeService.getMyPageInfo()
            
            await MainActor.run {
                isLoading = false
                
                switch result {
                case .success(let response):
                    storeInfo = response.data
                case .failure:
                    storeInfo = nil
                }
            }
        }
    }
    
    private var logoView: some View {
        HStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 101, height: 33)
            
            Spacer()
        }
        .padding(.top, 60)
        .padding(.horizontal, 27)
    }
    
    // 스켈레톤
    private var profileCardPlaceholder: some View {
        HStack(spacing: 14) {
            Circle()
                .frame(width: 60, height: 60)
                .foregroundColor(Color.napzakGrayScale(.gray100))
            
            VStack(alignment: .leading, spacing:7) {
                Rectangle()
                    .frame(width: 80, height: 14)
                    .foregroundColor(Color.napzakGrayScale(.gray100))
                
                HStack(spacing: 14) {
                    Rectangle()
                        .frame(width: 50, height: 12)
                        .foregroundColor(Color.napzakGrayScale(.gray100))
                    
                    Rectangle()
                        .frame(width: 50, height: 12)
                        .foregroundColor(Color.napzakGrayScale(.gray100))
                }
            }
            
            Spacer()
        }
        .padding(20)
        .background(Color.napzakGrayScale(.gray10))
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding(.horizontal, 27)
        .padding(.top, 30)
    }
    
    // API 프로필 정보
    private func profileCardWithData(storeInfo: StoreProfileDTO) -> some View {
        HStack(spacing: 14) {
            Circle()
                .frame(width: 60, height: 60)
                .overlay(
                    AsyncImage(url: URL(string: storeInfo.storePhoto)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Image("profile_img")
                            .resizable()
                            .scaledToFit()
                    }
                )
            
            VStack(alignment: .leading, spacing:7) {
                Text(storeInfo.storeNickname)
                    .applyNapzakFont(.body4Bold14)
                    .foregroundColor(Color.napzakPrimary(.purple500))
                
                HStack(spacing: 14) {
                    HStack(spacing: 2) {
                        Text("팔아요")
                            .applyNapzakFont(.caption2Medium12)
                            .foregroundColor(Color.napzakGrayScale(.gray500))
                        
                        Text("\(storeInfo.totalSellCount)개")
                            .applyNapzakFont(.caption1SemiBold12)
                            .foregroundColor(Color.napzakGrayScale(.gray500))
                    }
                    
                    HStack(spacing: 2) {
                        Text("구해요")
                            .applyNapzakFont(.caption2Medium12)
                            .foregroundColor(Color.napzakGrayScale(.gray500))
                        
                        Text("\(storeInfo.totalBuyCount)개")
                            .applyNapzakFont(.caption1SemiBold12)
                            .foregroundColor(Color.napzakGrayScale(.gray500))
                    }
                }
            }
            
            Spacer()
        }
        .padding(20)
        .background(Color.napzakGrayScale(.gray10))
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding(.horizontal, 27)
        .padding(.top, 30)
    }
    
    // 하드코딩된 프로필: 추후에 삭제 예정임다
    private var profileCard: some View {
        HStack(spacing: 14) {
            Circle()
                .frame(width: 60, height: 60)
                .overlay(
                    Image("profile_img")
                        .resizable()
                        .scaledToFit()
                )
            
            VStack(alignment: .leading, spacing:7) {
                Text("납작한 자기")
                    .applyNapzakFont(.body4Bold14)
                    .foregroundColor(Color.napzakPrimary(.purple500))
                
                HStack(spacing: 14) {
                    HStack(spacing: 2) {
                        Text("팔아요")
                            .applyNapzakFont(.caption2Medium12)
                            .foregroundColor(Color.napzakGrayScale(.gray500))
                        
                        Text("00개")
                            .applyNapzakFont(.caption1SemiBold12)
                            .foregroundColor(Color.napzakGrayScale(.gray500))
                    }
                    
                    HStack(spacing: 2) {
                        Text("구해요")
                            .applyNapzakFont(.caption2Medium12)
                            .foregroundColor(Color.napzakGrayScale(.gray500))
                        
                        Text("00개")
                            .applyNapzakFont(.caption1SemiBold12)
                            .foregroundColor(Color.napzakGrayScale(.gray500))
                    }
                }
            }
            
            Spacer()
        }
        .padding(20)
        .background(Color.napzakGrayScale(.gray10))
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding(.horizontal, 27)
        .padding(.top, 30)
    }
    
    private var marketButton: some View {
        VStack(spacing: 0) {
            Button {
                navigationRouter.push(next: .MarketView)
            } label: {
                HStack {
                    Spacer()
                    Text("내 마켓 보기")
                        .applyNapzakFont(.caption1SemiBold12)
                        .foregroundColor(Color.napzakGrayScale(.gray300))
                    
                    Image("arrow_right")
                    Spacer()
                }
                .padding()
                .background(Color.napzakGrayScale(.gray10))
                .clipShape(RoundedRectangle(cornerRadius: 17))
            }
            .padding(.horizontal, 27)
            .padding(.top, 20)
            
            Rectangle()
                .fill(Color.napzakGrayScale(.gray10))
                .frame(height: 4)
                .padding(.top, 20)
        }
    }
    
    private var menuGrid: some View {
        let menuItems: [(title: String, icon: String)] = [
            ("판매 내역", "group1_icn"),
            ("구매 내역", "group2_icn"),
            ("최근 본 상품", "group3_icn"),
            ("찜", "group4_icn"),
            ("설정", "group5_icn"),
            ("고객센터", "group6_icn")
        ]
        
        let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 3)
        
        return LazyVGrid(columns: columns, spacing: 4) {
            ForEach(menuItems.indices, id: \.self) { index in
                ZStack {
                    menuItem(title: menuItems[index].title, iconName: menuItems[index].icon)
                }
                .frame(maxWidth: .infinity, minHeight: 82)
                .background(Color.napzakGrayScale(.gray10))
            }
        }
        .background(Color.napzakGrayScale(.gray50))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 27)
        .padding(.top, 20)
        .padding(.bottom,30)
    }

    private func menuItem(title: String, iconName: String) -> some View {
        VStack(spacing: 5) {
            Image(iconName)
                .resizable()
                .frame(width: 36, height: 36)
            
            Text(title)
                .applyNapzakFont(.caption1SemiBold12)
                .foregroundColor(Color.napzakGrayScale(.gray400))
        }
    }
}

#Preview {
    MyPageView()
        .environmentObject(NavigationRouter())
}
