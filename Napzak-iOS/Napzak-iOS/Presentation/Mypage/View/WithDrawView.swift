//
//  WithDrawView.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/11/25.
//

import SwiftUI

struct WithdrawReasonMessage {
    static let hardToFindGoods = "원하는 굿즈를 찾기 어려워요"
    static let poorSales = "상품이 잘 안팔려요"
    static let inconvenientApp = "앱이 사용하기 불편해요"
    static let encounteredRudeUser = "비매너 사용자를 만났어요"
    static let wantNewAccount = "새 마켓(계정)을 만들고 싶어요"
    static let privacyConcerns = "개인정보 보호가 걱정돼요"
    static let noLongerInterested = "더 이상 덕질 활동을 하지 않아요"
    static let other = "다른 이유가 있어요"
}

struct WithDrawView: View {
    @EnvironmentObject private var navigationRouter: NavigationRouter
    
    @State var reasonExpanded: Bool = false
    @State var withdrawTitle: String = "원하는 굿즈를 찾기 어려워요"
    @State var withdrawDescription: String = ""
    
    var withDrawReasons: [String] {
        return [
            WithdrawReasonMessage.hardToFindGoods,
            WithdrawReasonMessage.poorSales,
            WithdrawReasonMessage.inconvenientApp,
            WithdrawReasonMessage.encounteredRudeUser,
            WithdrawReasonMessage.wantNewAccount,
            WithdrawReasonMessage.privacyConcerns,
            WithdrawReasonMessage.noLongerInterested,
            WithdrawReasonMessage.other
        ]
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0){
                    withDrawHeader
                    titleLabelSection
                    separator
                    secondTitleLabelSection
                    selectReasonSection
                    
                    Spacer()
                }
            }
            
            nextButton
        }
        .ignoresSafeArea()
        .background(.white)
        .navigationBarHidden(true)

    }
}

extension WithDrawView {
    private var withDrawHeader: some View {
        VStack(alignment: .leading) {
            Button {
                // 네비게이션 pop으로 교체
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
    
    private var separator: some View {
        Rectangle()
            .fill(Color.napzakGrayScale(.gray10))
            .frame(height: 7)
    }
    
    private var titleLabelSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("정말 떠나시나요?")
                .applyNapzakFont(.title2Bold20)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .frame(height: 26)
                .padding(.leading, 28)
                .padding(.bottom, 16)
            
            Text("탈퇴하시면 찜해둔 굿즈 목록과 거래 내역, 프로필 정보 및 채팅 기록, 받은 리뷰와 작성한 리뷰 등 모든 활동 정보가 삭제되어 복구할 수 없어요. \n\n쉬어가고 싶으시다면, \n앱을 잠시 사용하지 않는 방법도 있어요.")
                .applyNapzakFont(.body6Regular14)
                .foregroundStyle(Color.napzakGrayScale(.gray300))
                .padding(.horizontal, 28)
        }
        .padding(.bottom, 45)
        .background(.white)
    }
    
    private var secondTitleLabelSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("어떤 이유로 떠나고 싶으신가요?")
                .applyNapzakFont(.title2Bold20)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .frame(height: 26)
                .padding(.leading, 28)
                .padding(.bottom, 16)
                .padding(.top, 30)
            
            Text("그래도 탈퇴를 원하신다면, \n납작마켓이 더 나은 거래 공간이 될 수 있도록 \n그 이유를 알려주세요 🥹")
                .applyNapzakFont(.body6Regular14)
                .foregroundStyle(Color.napzakGrayScale(.gray300))
                .padding(.horizontal, 28)
                .padding(.bottom, 20)
        }
        
    }
    
    private var selectReasonSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack{
                Text(withdrawTitle)
                    .applyNapzakFont(.caption1SemiBold12)
                    .foregroundStyle(Color.napzakGrayScale(.gray300))
                    .frame(height: 15)
                    .padding(.leading, 16)
                
                Spacer()
                
                Image(systemName: reasonExpanded ? "chevron.up" : "chevron.down")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 10, height: 6)
                    .foregroundColor(Color.napzakGrayScale(.gray200))
                    .padding(.trailing, 20)
            }
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.napzakGrayScale(.gray200))
            )
            .onTapGesture {
                withAnimation {
                    reasonExpanded.toggle()
                }
            }
            
            if reasonExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(
                        withDrawReasons,
                        id: \.self
                    ) { reason in
                        Button(action: {
                            withdrawTitle = reason
                            reasonExpanded = false
                        }) {
                            Text(reason)
                                .applyNapzakFont(
                                    reason == withdrawTitle ? .caption1SemiBold12 : .caption2Medium12)
                                .foregroundColor(reason == withdrawTitle ? Color
                                    .napzakPrimary(.purple500) : Color
                                    .napzakGrayScale(.gray300))
                                .frame(height: 15)
                        }
                        
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 17)
            }
            
        }
        .background(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.napzakGrayScale(.gray200))
        )
        .padding(.horizontal, 28)
        .padding(.bottom, 114)
    }
    
    private var nextButton: some View {
        ZStack() {
            Color.napzakGrayScale(.white)
                .frame(height: 108)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 1)
            
            Button {
            } label: {
                Text("계속하기")
                    .applyNapzakFont(.body4Bold14)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
            }
            .background(Color.napzakGrayScale(.gray100))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding(.horizontal, 28)
            .padding(.top, 18)
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    WithDrawView()
}
