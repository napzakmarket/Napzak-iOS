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
                    
                    extraView
                    
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
    }
}

extension SellRegisterView {
    private var extraView: some View {
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
                .padding(.bottom, 30)
            
            SellRegisterPrice()
                .padding(.horizontal, 28)
                .padding(.bottom, 30)
            
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
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SellRegisterView()
}

