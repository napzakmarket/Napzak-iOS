//
//  RegisterProductStateSection.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/8/25.
//

import SwiftUI

struct SellRegisterProductState: View {
    @ObservedObject var viewModel: RegisterViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("상품 상태")
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .frame(height: 18)
                .padding(.bottom, 24)
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible())
                ],
                spacing: 12
            ) {
                ForEach(viewModel.options, id: \.self) { option in
                    Button {
                        viewModel.model.productCondition = option
                    } label: {
                        Text(option)
                            .applyNapzakFont(.body5SemiBold14)
                            .frame(height: 42)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(viewModel.model.productCondition == option ?
                                             Color.napzakPrimary(.purple500) :
                                                Color.napzakGrayScale(.gray200)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        option == viewModel.model.productCondition ?
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
