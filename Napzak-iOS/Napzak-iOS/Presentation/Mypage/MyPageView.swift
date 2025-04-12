//
//  MyPageView.swift
//  Napzak-iOS
//
//  Created by 어진 on 4/11/25.
//

import SwiftUI

struct MyPageView: View {
    private let storeNickName = "납작한 자기"
    private let sellingText = "팔아요"
    private let sellingCount = "31개"
    private let buyingText = "구해요"
    private let buyingCount = "15개"
    
    var body: some View {
        VStack(spacing: 0) {
            profileCard
            
            marketButton
            
            menuGrid
            
            Spacer()
        }
        .background(Color.napzakGrayScale(.white))
    }
    
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
                Text(storeNickName)
                    .font(.napzakFont(.body4Bold14))
                    .foregroundColor(Color.napzakPrimary(.purple500))
                
                HStack(spacing: 14) {
                    HStack(spacing: 2) {
                        Text(sellingText)
                            .font(.napzakFont(.caption2Medium12))
                            .foregroundColor(Color.napzakGrayScale(.gray500))
                        
                        Text(sellingCount)
                            .font(.napzakFont(.caption1SemiBold12))
                            .foregroundColor(Color.napzakGrayScale(.gray500))
                    }
                    
                    HStack(spacing: 2) {
                        Text(buyingText)
                            .font(.napzakFont(.caption2Medium12))
                            .foregroundColor(Color.napzakGrayScale(.gray500))
                        
                        Text(buyingCount)
                            .font(.napzakFont(.caption1SemiBold12))
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
        .padding(.top, 123)
    }
    
    private var marketButton: some View {
        Button {
            // 내 마켓 보기
        } label: {
            HStack {
                Spacer()
                Text("내 마켓 보기")
                    .font(.napzakFont(.caption1SemiBold12))
                    .foregroundColor(Color.napzakGrayScale(.gray300))
                
                
                Image("arrow_right")
                Spacer()
                
            }
            .padding()
            .background(Color.napzakGrayScale(.gray10))
            .clipShape(RoundedRectangle(cornerRadius: 17))
            .padding(.horizontal, 27)
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
        
        let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
        
        return LazyVGrid(columns: columns, spacing: 40) {
            ForEach(menuItems, id: \.title) { item in
                menuItem(title: item.title, iconName: item.icon)
            }
        }
        .padding(.vertical, 20)
        .background(Color.napzakGrayScale(.gray10))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 27)
        .padding(.top, 40)
    }
    
    private func menuItem(title: String, iconName: String) -> some View {
        VStack(spacing: 0) {
            Image(iconName)
                .resizable()
                .frame(width: 32)
                .padding(10)
            
            Text(title)
                .font(.napzakFont(.caption1SemiBold12))
                .foregroundColor(Color.napzakGrayScale(.gray400))
        }
    }
}


#Preview {
    MyPageView()
}
