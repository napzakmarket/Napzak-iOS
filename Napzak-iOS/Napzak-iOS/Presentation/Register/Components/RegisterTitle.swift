//
//  RegisterTitle.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/8/25.
//

import SwiftUI

struct RegisterTitle: View {
    @ObservedObject var viewModel: RegisterViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("상품명")
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .frame(height: 18)
                .padding(.bottom, 23)
            
            TextField("정확한 상품명을 포함하면 거래 확률이 올라가요", text: $viewModel.model.title)
                .maxLength(48, text: $viewModel.model.title)
                .applyNapzakFont(.body5SemiBold14)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .padding(.horizontal, 14)
                .padding(.vertical, 16)
                .frame(height: 50)
                .background {
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.napzakGrayScale(.gray100), lineWidth: 1)
                }
            
            HStack(spacing: 0) {
                Spacer()
                Text(viewModel.model.title.count.description)
                    .applyNapzakFont(.caption3Regular12)
                    .foregroundStyle(viewModel.model.title.count == 0 ? Color.napzakGrayScale(.gray300) : Color.napzakGrayScale(.gray500))
                
                Text("/48")
                    .applyNapzakFont(.caption3Regular12)
                    .foregroundStyle(Color.napzakGrayScale(.gray300))
            }
            .frame(height: 13)
        }
    }
}
