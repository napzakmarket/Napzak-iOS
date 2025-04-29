//
//  RegisterGenre.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/8/25.
//

import SwiftUI

struct RegisterGenre: View {
    @ObservedObject var viewModel: RegisterViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text("장르")
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .frame(height: 18)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
            
            Spacer()
            
            Text(viewModel.model.genre)
                .applyNapzakFont(.body5SemiBold14)
                .foregroundStyle(Color.napzakPrimary(.purple500))
                .frame(height: 18)
                .padding(.trailing, 5)
            
            Image(.iconGoRegister)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 12, height: 12)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .padding(.trailing, 10)
                .padding(.vertical, 8)
        }
        .frame(height: 34)
    }
}
