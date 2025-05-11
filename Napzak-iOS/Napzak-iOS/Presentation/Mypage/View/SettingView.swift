//
//  SettingView.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/11/25.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = SettingViewModel()
    
    @State var logoutButtonTapped: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0){
                settingViewHeader
                serviceInfo
                separator
                logoutButton
                separator
                withDrawButton
                Spacer()
            }
            
            if logoutButtonTapped {
                ZStack(alignment: .center){
                    Color.napzakTransparency(.transBlack)
                        .onTapGesture {
                            withAnimation {
                                logoutButtonTapped = false
                            }
                        }
                        .transition(.opacity)
                        .zIndex(1)
                    
                    NZAlertView(
                        style: .plain,
                        titleMessage: "로그아웃 하시겠어요?",
                        confirmText: "예",
                        cancelText: "아니요",
                        onConfirm: {
                            Task {
                                await viewModel.logOut()
                            }
                            logoutButtonTapped = false
                        },
                        onCancel: {
                            logoutButtonTapped = false
                        }
                    )
                    .zIndex(2)
                }
            }
        }
        .ignoresSafeArea()
        .background(Color.napzakGrayScale(.gray10))
    }
}

extension SettingView {
    private var settingViewHeader: some View {
        VStack(alignment: .leading) {
            Button {
                // 네비게이션 pop으로 교체
                dismiss
            } label: {
                HStack(alignment: .center, spacing: 0) {
                    Image(.iconBack)
                        .padding(.trailing,4)
                        .frame(width: 24, height: 24)
                    Text("설정")
                        .applyNapzakFont(.body1Bold16)
                        .foregroundStyle(Color.napzakGrayScale(.gray400))
                        .frame(height: 20)
                }
            }
            .padding(.top, 58)
            .padding(.bottom, 18)
            .padding(.leading, 20)
            
            Divider()
        }
        .frame(height: 100)
        .padding(.bottom, 28)
        .background(.white)
    }
    
    private var serviceInfo: some View {
        VStack(alignment: .leading, spacing: 0){
            Text("서비스 정보")
                .applyNapzakFont(.body6Regular14)
                .foregroundStyle(Color.napzakGrayScale(.gray400))
                .frame(height: 18)
                .padding(.leading, 28)
                .padding(.bottom, 28)
            
            Button {
                // 공지사항 이동
                print("공지사항 이동")
            } label: {
                HStack {
                    Text("공지사항")
                        .applyNapzakFont(.body1Bold16)
                        .foregroundStyle(Color.napzakGrayScale(.gray400))
                        .frame(height: 20)
                    Spacer()
                    Image(.arrowRight)
                        .resizable()
                        .frame(width: 6, height: 10)
                }
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 20)
            
            Button {
                // 이용약관 이동
                print("이용약관 이동")
            } label: {
                HStack {
                    Text("이용약관")
                        .applyNapzakFont(.body1Bold16)
                        .foregroundStyle(Color.napzakGrayScale(.gray400))
                        .frame(height: 20)
                    Spacer()
                    Image(.arrowRight)
                        .resizable()
                        .frame(width: 6, height: 10)
                }
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 20)
            
            Button {
                // 개인정보 처리방침 이동
                print("개인정보 처리방침 이동")
            } label: {
                HStack {
                    Text("개인정보 처리방침")
                        .applyNapzakFont(.body1Bold16)
                        .foregroundStyle(Color.napzakGrayScale(.gray400))
                        .frame(height: 20)
                    Spacer()
                    Image(.arrowRight)
                        .resizable()
                        .frame(width: 6, height: 10)
                }
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 20)
            
            Button {
                // 버전 정보 이동
                print("버전 정보 이동")
            } label: {
                HStack {
                    Text("버전 정보")
                        .applyNapzakFont(.body1Bold16)
                        .foregroundStyle(Color.napzakGrayScale(.gray400))
                        .frame(height: 20)
                    Spacer()
                    Image(.arrowRight)
                        .resizable()
                        .frame(width: 6, height: 10)
                }
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 28)
        }
        .background(.white)
    }
    
    private var separator: some View {
        Rectangle()
            .fill(Color.napzakGrayScale(.gray10))
            .frame(height: 7)
    }
    
    private var logoutButton: some View {
        HStack(alignment: .center, spacing: 0) {
            Button {
                logoutButtonTapped = true
            } label: {
                Text("로그아웃")
                    .applyNapzakFont(.body1Bold16)
                    .foregroundStyle(Color.napzakPrimary(.purple500))
                    .frame(height: 20)
            }
            .padding(.leading, 28)
            .padding(.vertical, 28)
            
            Spacer()
        }
        .background(.white)
    }
    
    private var withDrawButton: some View {
        HStack(alignment: .center, spacing: 0) {
            Button {
                // 탈퇴 뷰 이동
                print("탈퇴 뷰 이동")
            } label: {
                Text("탈퇴하기")
                    .applyNapzakFont(.body1Bold16)
                    .foregroundStyle(.red)
                    .frame(height: 20)
            }
            .padding(.leading, 28)
            .padding(.vertical, 28)
            
            Spacer()
        }
        .background(.white)
    }
}

#Preview {
    SettingView()
}


