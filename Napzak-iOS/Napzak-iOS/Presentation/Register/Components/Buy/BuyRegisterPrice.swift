//
//  BuyRegisterPrice.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/9/25.
//

import SwiftUI

struct BuyRegisterPrice: View {
    @ObservedObject var viewModel: RegisterViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("희망 가격")
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .frame(height: 18)
                .padding(.bottom, 4)
            
            Text("얼마에 거래하고 싶으신가요? (1천원 단위, 최대 100만원)")
                .applyNapzakFont(.caption2Medium12)
                .foregroundStyle(Color.napzakGrayScale(.gray300))
                .frame(height: 15)
                .padding(.bottom, 24)
            
            HStack(alignment: .center, spacing: 0){
                TextField("", text: $viewModel.model.price)
                    .keyboardType(.decimalPad)
                    .applyNapzakFont(.body4Bold14)
                    .multilineTextAlignment(.trailing)
                    .foregroundStyle(viewModel.priceError ? .red : Color.napzakGrayScale(.gray400))
                    .onChange(of: viewModel.model.price) { newValue in
                        viewModel.model.price = newValue.convertPrice(maxPrice: viewModel.maxPrice)
                        if viewModel.model.price.convertInt() % 1000 != 0 {
                            viewModel.priceError = true
                        } else {
                            viewModel.priceError = false
                        }
                    }
                
                Text(" 원대")
                    .applyNapzakFont(.body5SemiBold14)
                    .foregroundStyle(
                        viewModel.model.price == "" ? Color.napzakGrayScale(.gray200) : viewModel.priceError ? .red : Color.napzakGrayScale(.gray400))
                    .padding(.trailing, 12)
            }
            .frame(height: 50)
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(viewModel.priceError ? .red : Color.napzakGrayScale(.gray100), lineWidth: 1)
            }
            .padding(.bottom, viewModel.priceError ? 8 : 14)
            
            if viewModel.priceError {
                HStack(alignment: .center, spacing: 0){
                    Spacer()
                    
                    Image(.iconWarning)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 9, height: 9)
                        .padding(.trailing, 2)
                    
                    Text("가격 설정은 1,000원 단위로만 가능해요")
                        .applyNapzakFont(.caption4SemiBold10)
                        .foregroundStyle(.red)
                        .frame(height: 13)
                }
                .padding(.bottom, 8)
                
            }
            
            HStack(spacing: 8) { // 버튼 사이 간격 설정
                ForEach(viewModel.addPrices, id: \.self) { addPrice in
                    Button {
                        viewModel.model.price = (viewModel.model.price.convertInt() + addPrice.convertInt()).description
                            .convertPrice(maxPrice: viewModel.maxPrice)
                    } label: {
                        Text(addPrice)
                            .applyNapzakFont(.caption2Medium12)
                            .foregroundColor(.napzakGrayScale(.gray100))
                            .frame(height: 24)
                            .frame(minWidth: 72)
                            .background(Color.napzakGrayScale(.gray10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.napzakGrayScale(.gray100), lineWidth: 1)
                            )
                    }
                }
            }
            
        }
    }
}
