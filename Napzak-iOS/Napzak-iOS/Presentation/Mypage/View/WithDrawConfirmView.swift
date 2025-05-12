//
//  WithDrawConfirmView.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/12/25.
//

import SwiftUI

struct WithDrawConfirmView: View {
    @EnvironmentObject private var navigationRouter: NavigationRouter
    
    @StateObject var viewModel = WithDrawViewModel.shared

    @State var withDrawButtonTapped: Bool = false

    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 0) {
                withDrawHeader
                titleLabelSection
                
                Spacer()
                
                nextButtonSection
            }
            
            if withDrawButtonTapped {
                Color.napzakTransparency(.transBlack)
                    .onTapGesture {
                        withAnimation {
                            withDrawButtonTapped = false
                        }
                    }
                    .transition(.opacity)
                    .zIndex(1)
                
                NZAlertView(
                    message: "정말 탈퇴하시겠어요?",
                    confirmText: "예",
                    cancelText: "아니요",
                    onConfirm: {
                        Task {
                            await viewModel.withdraw()
                        }
                        withDrawButtonTapped = false
                        navigationRouter.reset()
                    },
                    onCancel: {
                        withDrawButtonTapped = false
                    }
                )
                .padding(.horizontal, 45)
                .zIndex(2)
            }
        }
        .ignoresSafeArea()
        .background(.white)
        .navigationBarHidden(true)
    }
}

extension WithDrawConfirmView {
    private var withDrawHeader: some View {
        VStack(alignment: .leading) {
            Button {
                navigationRouter.pop()
            } label: {
                HStack(alignment: .center, spacing: 0) {
                    Image(.iconBack)
                        .padding(.trailing,4)
                        .frame(width: 24, height: 24)
                    Text("탈퇴하기")
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
        .padding(.bottom, 40)
        .background(.white)
    }
    
    private var titleLabelSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("탈퇴 전 꼭 확인해주세요!")
                .applyNapzakFont(.title2Bold20)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .frame(height: 26)
                .padding(.leading, 28)
                .padding(.bottom, 16)
            
            Text("탈퇴 시, 유저님의 개인정보는 모두 삭제되며 복구가 불가능합니다. \n\n• 프로필 정보 및 계정 설정, 찜한 상품 및 최근 본 상품 목록, \n모든 채팅 내역 및 거래 기록, 등록한 상품 및 구매/판매 내역, \n받은 리뷰 및 작성한 리뷰 등")
                .applyNapzakFont(.caption3Regular12)
                .foregroundStyle(Color.napzakGrayScale(.black))
                .padding(.horizontal, 30)
                .padding(.bottom, 17)
            
            Text("탈퇴 후 동일한 계정으로 재가입하셔도 \n이전 데이터는 복구되지 않습니다.")
                .applyNapzakFont(.caption3Regular12)
                .foregroundStyle(Color.napzakGrayScale(.black))
                .padding(.horizontal, 30)
                .padding(.bottom, 17)
            
            Text("현재 진행 중인 거래가 있다면, \n반드시 완료하거나 상대방과 협의 후 취소할 것을 권장합니다.")
                .applyNapzakFont(.caption3Regular12)
                .foregroundStyle(Color.napzakGrayScale(.black))
                .padding(.horizontal, 30)
                .padding(.bottom, 17)
        }
    }
    
    private var nextButtonSection: some View {
        HStack(alignment: .center, spacing: 16) {
            Button {
                navigationRouter.pop()
                print("취소하기 눌림")
            } label: {
                Text("취소하기")
                    .applyNapzakFont(.body4Bold14)
                    .foregroundStyle(Color.napzakPrimary(.purple500))
                    .frame(maxWidth: .infinity, minHeight: 50)
            }
            .background(Color.napzakPrimary(.purple100))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            
            Button {
                withDrawButtonTapped = true
            } label: {
                Text("탈퇴하기")
                    .applyNapzakFont(.body4Bold14)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
            }
            .background(Color.napzakPrimary(.purple500))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 52)
    }

}
