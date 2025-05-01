//
//  RegisterImage.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/8/25.
//

import SwiftUI

struct RegisterImage: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("상품 이미지")
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .frame(height: 18)
                .padding(.bottom, 4)
            
            Text("꾹 눌러서 대표 이미지를 변경할 수 있어요")
                .applyNapzakFont(.caption2Medium12)
                .foregroundStyle(Color.napzakGrayScale(.gray300))
                .frame(height: 15)
                .padding(.bottom, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    VStack {
                        Image(.iconPhotoPicker)
                            .frame(width: 24, height: 24)
                        
                        Text("사진 0/10")
                            .applyNapzakFont(.caption3Regular12)
                            .foregroundStyle(Color.napzakPrimary(.purple500))
                            .frame(height: 13)
                    }
                    .frame(width: 88, height: 88)
                    .background(Color.napzakPrimary(.purple100))
                    .clipShape(.rect(cornerRadius: 5))
                    
//                    ForEach(0..<selectedImages.count, id: \.self) { index in
//                        imageItemView(for: index)
//                    }
                }
            }
            

            
        }
    }
}

#Preview {
    RegisterImage()
}
