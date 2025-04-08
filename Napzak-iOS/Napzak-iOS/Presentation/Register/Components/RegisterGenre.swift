//
//  RegisterGenre.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/8/25.
//

import SwiftUI

struct RegisterGenre: View {
    var body: some View {
        HStack{
            Text("장르")
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
            
            Spacer()
            
            Image(.iconGoRegister)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 12, height: 12)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
            
        }
    }
}

#Preview {
    RegisterGenre()
}
