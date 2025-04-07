//
//  RegisterHeader.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/8/25.
//

import SwiftUI

struct SellRegisterHeader: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack{
                backButton
                navigationTitle
            }
            .padding(.bottom, 20)
            
            Divider()
        }
        
    }
}

// MARK: - Subviews

extension SellRegisterHeader {
    
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
            
            Text("팔아요 등록")
                .applyNapzakFont(.body1Bold16)
                .foregroundStyle(Color.napzakGrayScale(.gray400))
            
            Spacer()
        }
        
    }
    
}


#Preview {
    SellRegisterHeader()
}
