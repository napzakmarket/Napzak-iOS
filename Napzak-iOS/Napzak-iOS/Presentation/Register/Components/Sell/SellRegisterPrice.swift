//
//  SellRegisterPrice.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/8/25.
//

import SwiftUI

struct SellRegisterPrice: View {
    @State var price: String = ""
    private let maxPrice: Int = 1_000_000       // 최대 금액 100만원
    let addPrices = ["+1,000원", "+5,000원", "+10,000원", "+100,000원"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("가격")
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .padding(.bottom, 4)
            
            Text("얼마에 거래하고 싶으신가요? (최대 100만원)")
                .applyNapzakFont(.caption2Medium12)
                .foregroundStyle(Color.napzakGrayScale(.gray300))
                .padding(.bottom, 24)
            
            // TODO: - 디자인 답변 받으면 금액과 '원' 사이 간격 spacing 반영하기
            HStack(alignment: .center, spacing: 0){
                TextField("", text: $price)
                    .keyboardType(.decimalPad)
                    .applyNapzakFont(.body4Bold14)
                    .multilineTextAlignment(.trailing)
                    .foregroundStyle(Color.napzakGrayScale(.gray400))
                    .onChange(of: price) { newValue in
                        price = newValue.convertPrice(maxPrice: maxPrice)
                    }
                
                Text("원")
                    .applyNapzakFont(.body5SemiBold14)
                    .foregroundStyle(
                        price == "" ? Color.napzakGrayScale(.gray200) : Color
                            .napzakGrayScale(.gray400))
                    .padding(.trailing, 12)
            }
            .frame(height: 50)
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.napzakGrayScale(.gray100), lineWidth: 1)
            }
            .padding(.bottom, 14)
            
            HStack(spacing: 8) { // 버튼 사이 간격 설정
                ForEach(addPrices, id: \.self) { addPrice in
                    Button {
                        price = (price.convertInt() + addPrice.convertInt()).description
                            .convertPrice(maxPrice: maxPrice)
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
