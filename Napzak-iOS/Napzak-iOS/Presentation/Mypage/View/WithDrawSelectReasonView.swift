//
//  WithDrawSelectReasonView.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/11/25.
//

import SwiftUI

struct WithDrawSelectReasonView: View {
    @EnvironmentObject private var navigationRouter: NavigationRouter

    @StateObject private var viewModel = WithDrawViewModel.shared

    @State var reasonExpanded: Bool = false

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

extension WithDrawSelectReasonView {
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
                Text(viewModel.withdrawReasonTitle)
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
                        viewModel.withDrawReasons,
                        id: \.self
                    ) { reason in
                        Button(action: {
                            viewModel.withdrawReasonTitle = reason
                            reasonExpanded = false
                        }) {
                            Text(reason)
                                .applyNapzakFont(
                                    reason == viewModel.withdrawReasonTitle ? .caption1SemiBold12 : .caption2Medium12)
                                .foregroundColor(reason == viewModel.withdrawReasonTitle ? Color
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
        Button {
            navigationRouter.push(next: .withDrawWriteReasonView)
        } label: {
            Text("계속하기")
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, minHeight: 50)
        }
        .background(Color.napzakPrimary(.purple500))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 28)
        .padding(.bottom, 40)
    }
}

#Preview {
    WithDrawSelectReasonView()
}
