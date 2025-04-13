//
//  BuyRegisterView.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/9/25.
//

import SwiftUI

struct BuyRegisterView: View {
    
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
        Group {
            RegisterImage()
                .padding(.top, 30)
                .padding(.horizontal, 28)
                .padding(.bottom, 27)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
            
            RegisterGenre()
                .padding(.horizontal, 18)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 21)
                .background(.white)
            
            Rectangle()
                .fill(Color.napzakGrayScale(.gray10))
                .frame(height: 4)
                .padding(.bottom, 29)
                .background(.white)

            RegisterTitle()
                .padding(.horizontal, 28)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 10)
                .background(.white)

            RegisterDescription()
                .padding(.horizontal, 28)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 23)
                .background(.white)

            Rectangle()
                .fill(Color.napzakGrayScale(.gray10))
                .frame(height: 4)
                .padding(.bottom, 23)
                .background(.white)

            BuyRegisterPrice()
                .padding(.horizontal, 28)
                .padding(.bottom, 32)
                .background(.white)

            BuyRegisterSuggestPrice()
                .padding(.horizontal, 28)

            
        }
    }
    
    private var registerButton: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.black.opacity(0.05))
                .frame(height: 1)
            
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
            .background(.white)
        }
    }
    
}


#Preview {
    BuyRegisterView()
}

