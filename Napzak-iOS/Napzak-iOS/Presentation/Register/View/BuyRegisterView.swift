//
//  BuyRegisterView.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/9/25.
//

import SwiftUI

struct BuyRegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    
    var body: some View {
        VStack(spacing: 0){
            BuyRegisterHeader()

            ScrollView {
                VStack(spacing: 0) {
                    BuyRegisterContent
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            registerButton
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity)
        .scrollIndicators(.hidden)
        .background(Color.napzakGrayScale(.gray10))
    }
}

extension BuyRegisterView {
    private var BuyRegisterContent: some View {
        VStack(spacing: 0) {
            RegisterImage()
                .padding(.top, 30)
                .padding(.horizontal, 28)
                .padding(.bottom, 27)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
            
            RegisterGenre(viewModel: viewModel)
                .padding(.horizontal, 18)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 21)
                .background(.white)
            
            Rectangle()
                .fill(Color.napzakGrayScale(.gray10))
                .frame(height: 4)
                .padding(.bottom, 29)
                .background(.white)

            RegisterTitle(viewModel: viewModel)
                .padding(.horizontal, 28)
                .padding(.bottom, 10)
                .background(.white)

            RegisterDescription(viewModel: viewModel)
                .padding(.horizontal, 28)
                .padding(.bottom, 23)
                .background(.white)

            Rectangle()
                .fill(Color.napzakGrayScale(.gray10))
                .frame(height: 4)
                .padding(.bottom, 23)
                .background(.white)

            BuyRegisterPrice(viewModel: viewModel)
                .padding(.horizontal, 28)
                .padding(.bottom, 32)
                .background(.white)

            BuyRegisterSuggestPrice(viewModel: viewModel)
                .padding(.horizontal, 28)
        }
    }
    
    private var registerButton: some View {
        ZStack() {
            Color.napzakGrayScale(.white)
                .frame(height: 108)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 1)
            
            Button {
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
    BuyRegisterView()
}

