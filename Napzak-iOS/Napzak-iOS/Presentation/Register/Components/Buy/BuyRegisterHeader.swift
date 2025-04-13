//
//  BuyRegisterHeader.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/9/25.
//

import SwiftUI

struct BuyRegisterHeader: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            ZStack{
                backButton
                navigationTitle
            }
            .padding(.bottom, 20)
            
            Divider()
        }
        .background(.white)
        .frame(height: 110)

    }
}

// MARK: - Subviews

extension BuyRegisterHeader {
    
    private var backButton: some View {
        HStack {
            Spacer()
            
            Button {
                dismiss()
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
            
            Text("구해요 등록")
                .applyNapzakFont(.body1Bold16)
                .foregroundStyle(Color.napzakGrayScale(.gray400))
                .frame(height: 18)
            
            Spacer()
        }
        
    }
    
}

#Preview {
    BuyRegisterHeader()
}
