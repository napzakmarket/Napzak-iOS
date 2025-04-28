//
//  SellRegisterView.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/8/25.
//

import SwiftUI

struct SellRegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    
    var body: some View {
        VStack(spacing: 0){
            SellRegisterHeader()
            
            ScrollView {
                VStack(spacing: 0) {
                    SellRegisterContent
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            registerButton
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity)
        .scrollIndicators(.hidden)
    }
}

extension SellRegisterView {
    private var SellRegisterContent: some View {
        VStack(spacing: 0) {
            RegisterImage()
                .padding(.top, 30)
                .padding(.horizontal, 28)
                .padding(.bottom, 27)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            RegisterGenre()
                .padding(.horizontal, 18)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 21)
            
            Rectangle()
                .fill(Color.napzakGrayScale(.gray10))
                .frame(height: 4)
                .padding(.bottom, 29)
            
            RegisterTitle(viewModel: viewModel)
                .padding(.horizontal, 28)
                .padding(.bottom, 10)
            
            RegisterDescription(viewModel: viewModel)
                .padding(.horizontal, 28)
                .padding(.bottom, 23)
            
            Rectangle()
                .fill(Color.napzakGrayScale(.gray10))
                .frame(height: 4)
                .padding(.bottom, 23)
            
            SellRegisterProductState(viewModel: viewModel)
                .padding(.horizontal, 28)
                .padding(.bottom, 30)
            
            SellRegisterPrice(viewModel: viewModel)
                .padding(.horizontal, 28)
                .padding(.bottom, 30)
            
            SellRegisterDelivery(viewModel: viewModel)
                .padding(.horizontal, 28)
        }
    }
    
    private var registerButton: some View {
        ZStack() {
            Color.napzakGrayScale(.white)
                .frame(height: 108)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 1)
            
            Button {
                //MARK: - 팔아요 등록
                print("버튼 눌림")
            } label: {
                Text("등록하기")
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
    SellRegisterView()
}

