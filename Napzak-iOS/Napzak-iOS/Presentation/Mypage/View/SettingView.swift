//
//  SettingView.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/11/25.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject private var navigationRouter: NavigationRouter
    @EnvironmentObject private var tabRouter: TabRouter
    @EnvironmentObject private var pushManger: PushManager
    @EnvironmentObject private var permissionManager: PushPermissionManager
    
    @Environment(\.openURL) var openURL
    
    @StateObject private var viewModel = SettingViewModel()
    @StateObject private var withDrawViewModel = WithDrawViewModel.shared
    
    @State var logoutButtonTapped: Bool = false
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    var body: some View {
        ZStack {
            VStack(spacing: 0){
                settingViewHeader
                appPushToggleView
                separator
                serviceInfo
                separator
                logoutButton
                separator
                withDrawButton
                Spacer()
            }
            
            if logoutButtonTapped {
                Color.napzakTransparency(.transBlack)
                    .onTapGesture {
                        withAnimation {
                            logoutButtonTapped = false
                        }
                    }
                    .transition(.opacity)
                    .zIndex(1)
                
                NZAlertView(
                    style: .primary,
                    titleMessage: "로그아웃 하시겠어요?",
                    confirmText: "예",
                    cancelText: "아니요",
                    onConfirm: {
                        Task {
                            await pushManger.removeToken()
                            await viewModel.logout()
                            navigationRouter.reset()
                            tabRouter.switchToHome()
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
        .background(Color.napzakGrayScale(.gray10))
        .navigationBarHidden(true)
        .onAppear {
            withDrawViewModel.resetWithdraw()
        }
    }
}

extension SettingView {
    private var settingViewHeader: some View {
        VStack(alignment: .leading) {
            Button {
                navigationRouter.pop()
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
            .padding(.bottom, 18)
            .padding(.leading, 20)
            
            Divider()
        }
        .background(.white)
    }
    
    private var serviceInfo: some View {
        VStack(alignment: .leading, spacing: 0){
            Text("서비스 정보")
                .applyNapzakFont(.body5SemiBold14)
                .foregroundStyle(Color.napzakGrayScale(.gray200))
                .frame(height: 18)
                .padding(.leading, 28)
                .padding(.bottom, 28)
            
            Button {
                guard let url = URL(string: Bundle.main.infoDictionary?["NOTICE_URL"] as! String) else {return}
                openURL(url)
                print("공지사항 이동")
            } label: {
                HStack {
                    Text("공지사항")
                        .applyNapzakFont(.body7Medium16)
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
                guard let url = URL(string: Bundle.main.infoDictionary?["TERMS_OF_SERVICE_URL"] as! String) else {return}
                openURL(url)
                print("이용약관 이동")
            } label: {
                HStack {
                    Text("이용약관")
                        .applyNapzakFont(.body7Medium16)
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
                guard let url = URL(string: Bundle.main.infoDictionary?["PRIVACY_POLICY_URL"] as! String) else {return}
                openURL(url)
                print("개인정보 처리방침 이동")
            } label: {
                HStack {
                    Text("개인정보 처리방침")
                        .applyNapzakFont(.body7Medium16)
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
            
            HStack {
                Text("버전 정보")
                    .applyNapzakFont(.body7Medium16)
                    .foregroundStyle(Color.napzakGrayScale(.gray400))
                    .frame(height: 20)
                Spacer()
                Text(appVersion ?? "버전 정보가 없습니다")
                    .applyNapzakFont(.body7Medium16)
                    .foregroundStyle(Color.napzakGrayScale(.gray400))
                    .frame(height: 20)
                
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
        Button {
            logoutButtonTapped = true
        } label: {
            HStack(alignment: .center, spacing: 0) {
                Text("로그아웃")
                    .applyNapzakFont(.body1Bold16)
                    .foregroundStyle(Color.napzakPrimary(.purple500))
                    .frame(height: 20)
                Spacer()
            }
        }
        .padding(.leading, 28)
        .padding(.vertical, 28)
        .background(.white)
    }
    
    private var withDrawButton: some View {
        Button {
            navigationRouter.push(next: .withDrawSelectReasonView)
        } label: {
            HStack(alignment: .center, spacing: 0) {
                Text("탈퇴하기")
                    .applyNapzakFont(.body1Bold16)
                    .foregroundStyle(.red)
                    .frame(height: 20)
                Spacer()
            }
        }
        .padding(.leading, 28)
        .padding(.vertical, 28)
        .background(.white)
    }
    
    private var appPushToggleView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("알림")
                .applyNapzakFont(.body5SemiBold14)
                .foregroundStyle(Color.napzakGrayScale(.gray200))
                .frame(height: 18)
                .padding(.vertical, 24)
            
            HStack {
                Toggle(isOn: $permissionManager.isAppPushEnabled) {
                    Text(permissionManager.isAppPushEnabled ? "앱 알림" : "기기 알림이 꺼져있어요.")
                        .applyNapzakFont(.body7Medium16)
                        .foregroundStyle(permissionManager.isAppPushEnabled ? Color.napzakGrayScale(.gray400) : Color.napzakState(.red))
                        .frame(height: 20)
                }
                .toggleStyle(CustomToggleStyle())
            }
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 24)
        .background(.white)
    }
}

#Preview {
    SettingView()
        .environmentObject(PushPermissionManager())
}
