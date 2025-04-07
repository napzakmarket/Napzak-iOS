//
//  RegisterImageSection.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/8/25.
//

import SwiftUI

struct RegisterImageSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("상품 이미지")
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .padding(.bottom, 4)
            
            Text("꾹 눌러서 대표 이미지를 변경할 수 있어요")
                .applyNapzakFont(.caption2Medium12)
                .foregroundStyle(Color.napzakGrayScale(.gray300))
                .padding(.bottom, 16)
            
            VStack{
                Image(.iconPhotoPicker)
                
                Text("사진 0/10")
                    .applyNapzakFont(.caption3Regular12)
                    .foregroundStyle(Color.napzakPrimary(.purple500))
            }
            .frame(width: 88, height: 88)
            .background(Color.napzakPrimary(.purple100))
            .clipShape(.rect(cornerRadius: 5))
            
        }
    }
}
