//
//  BuyRegisterSuggestPrice.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/14/25.
//

import SwiftUI

struct BuyRegisterSuggestPrice: View {
    @ObservedObject var viewModel: RegisterViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("가격 제시")
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .frame(height: 18)
                .padding(.top, 32)
                .padding(.bottom, 4)
            
            Text("희망가격 외에도 다양한 가격 제안을 받아볼 수 있어요")
                .applyNapzakFont(.caption2Medium12)
                .foregroundStyle(Color.napzakGrayScale(.gray300))
                .frame(height: 15)
                .padding(.bottom, 23)
            
            HStack(alignment: .center, spacing: 0) {
                Image(viewModel.model.suggestPrice ? .buttonCheckboxFill : .buttonCheckbox)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(.trailing, 11)
                    .onTapGesture {
                        viewModel.model.suggestPrice.toggle()
                    }
                
                Text("받기")
                    .applyNapzakFont(.body4Bold14)
                    .foregroundStyle(Color.napzakGrayScale(.gray500))
                    .frame(height: 18)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 58)
        }
    }
}
