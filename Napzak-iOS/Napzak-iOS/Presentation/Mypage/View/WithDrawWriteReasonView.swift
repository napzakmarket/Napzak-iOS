//
//  WithDrawWriteReasonView.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/12/25.
//

import SwiftUI

struct WithDrawWriteReasonView: View {
    @EnvironmentObject private var navigationRouter: NavigationRouter
    @FocusState private var isSearchBarFocused: Bool
    @StateObject var viewModel = WithDrawViewModel.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            withDrawHeader
            titleLabelSection
            writeReasonSection
            
            Spacer()
            
            nextButtonSection
        }
        .onTapGesture {
            isSearchBarFocused = false
        }
        .ignoresSafeArea()
        .background(.white)
        .navigationBarHidden(true)
    }
}

extension WithDrawWriteReasonView {
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
            Text("더 자세한 이야기가 궁금해요")
                .applyNapzakFont(.title2Bold20)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .frame(height: 26)
                .padding(.leading, 28)
                .padding(.bottom, 16)
        }
        .background(.white)
    }
    
    private var writeReasonSection: some View {
        ZStack(alignment: .topLeading){
            TextEditor(text: $viewModel.withdrawDescription)
                .scrollContentBackground(.hidden)
                .applyNapzakFont(.body5SemiBold14)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .padding(.horizontal, 6)
                .padding(.vertical, 7)
                .focused($isSearchBarFocused)
            
            if viewModel.withdrawDescription.isEmpty {
                Text("어떤 점이 불편하셨는지 솔직히 알려주시면 큰 도움이 됩니다.\n소중한 의견을 바탕으로 더 나은 거래 공간을 만들겠습니다!")
                    .applyNapzakFont(.caption3Regular12)
                    .foregroundStyle(Color.napzakGrayScale(.gray200))
                    .padding(.leading, 12)
                    .padding(.vertical, 16)
            }
        }
        .frame(height: 416)
        .background(Color.napzakGrayScale(.gray10))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 28)
    }
    
    private var nextButtonSection: some View {
        VStack(spacing: 0) {
            Button {
                navigationRouter.push(next: .withDrawConfirmView)
                print("계속하기 눌림")
            } label: {
                Text("계속하기")
                    .applyNapzakFont(.body4Bold14)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
            }
            .background(
                viewModel.withdrawDescription.isEmpty ? Color
                    .napzakGrayScale(.gray100) : Color
                    .napzakPrimary(.purple500)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding(.horizontal, 28)
            .padding(.bottom, 16)
            
            Button {
                navigationRouter.push(next: .withDrawConfirmView)
                print("건너뛰기")
            } label: {
                Text("건너뛰기")
                    .applyNapzakFont(.body4Bold14)
                    .foregroundStyle(Color.napzakGrayScale(.gray300))
                    .frame(height: 15)
            }
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding(.horizontal, 28)
            .padding(.bottom, 40)
        }
    }

}
