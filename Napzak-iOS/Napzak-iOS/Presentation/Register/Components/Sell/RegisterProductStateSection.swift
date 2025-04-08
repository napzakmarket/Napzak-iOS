//
//  RegisterProductStateSection.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/8/25.
//

import SwiftUI

struct RegisterProductStateSection: View {
    @State var productState: String = ""
    
    private let options = ["미개봉", "아주 좋은 상태", "약간의 사용감", "사용감 있음"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("상품 상태")
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .padding(.bottom, 24)
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible())
                ],
                spacing: 12
            ) {
                ForEach(options, id: \.self) { option in
                    Button {
                        productState = option
                    } label: {
                        Text(option)
                            .applyNapzakFont(.body5SemiBold14)
                            .frame(height: 42) // ❗️높이만 지정
                            .frame(maxWidth: .infinity) // 그리드 셀 안에서 최대 너비
                            .foregroundColor(productState == option ?
                                             Color.napzakPrimary(.purple500) :
                                                Color.napzakGrayScale(.gray200)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        option == productState ?
                                        Color.napzakPrimary(.purple500) :
                                            Color.napzakGrayScale(.gray100),
                                        lineWidth: 1
                                    )
                            )
                    }
                }
            }
        }

    }
}
