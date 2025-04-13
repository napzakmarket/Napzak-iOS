//
//  SellRegisterView.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/8/25.
//

import SwiftUI

struct SellRegisterView: View {
    var body: some View {
        VStack{
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
        Group {
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
            
            RegisterTitle()
                .padding(.horizontal, 28)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 10)
            
            RegisterDescription()
                .padding(.horizontal, 28)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 23)
            
            Rectangle()
                .fill(Color.napzakGrayScale(.gray10))
                .frame(height: 4)
                .padding(.bottom, 23)
            
            SellRegisterProductState()
                .padding(.horizontal, 28)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 30)
            
            SellRegisterPrice()
                .padding(.horizontal, 28)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 30)
            
            SellRegisterDelivery()
                .padding(.horizontal, 28)
                .frame(maxWidth: .infinity)

            
        }
    }
    
    private var registerButton: some View {
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
        .frame(maxWidth: .infinity)
        .background(.white)
    }
}

#Preview {
    SellRegisterView()
}

