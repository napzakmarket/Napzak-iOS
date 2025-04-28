//
//  RegisterHeader.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/8/25.
//

import SwiftUI

struct SellRegisterHeader: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            ZStack{
                clearButton
                navigationTitle
            }
            .padding(.bottom, 20)
            
            Divider()
        }
        .frame(height: 110)
    }
}

// MARK: - Subviews

extension SellRegisterHeader {
    
    private var clearButton: some View {
        HStack {
            Spacer()
            
            Button {
                //TODO: - 뒤로가기
            } label: {
                Image(.iconClose)
            }
            .frame(width: 24, height: 24)
            
        }
        .padding(.trailing, 20)
    }
    
    private var navigationTitle: some View {
        HStack {
            Spacer()
            
            Text("팔아요 등록")
                .applyNapzakFont(.body1Bold16)
                .foregroundStyle(Color.napzakGrayScale(.gray400))
                .frame(height: 18)
            
            Spacer()
        }
    }
}


#Preview {
    SellRegisterHeader()
}
