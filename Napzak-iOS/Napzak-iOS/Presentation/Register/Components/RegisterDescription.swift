//
//  RegisterDescription.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/8/25.
//

import SwiftUI

struct RegisterDescription: View {
    @Binding var description: String

    var body: some View {
        VStack(alignment: .leading) {
            Text("상품 설명")
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .frame(height: 18)
                .padding(.bottom, 23)
            
            ZStack(alignment: .topLeading){
                TextEditor(text: $description)
                    .maxLength(430, text: $description)
                    .applyNapzakFont(.body5SemiBold14)
                    .foregroundStyle(Color.napzakGrayScale(.gray500))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 7)
                
                if description.isEmpty {
                    Text("자세히 작성하면 더 빠르고 원활한 거래를 할 수 있어요 \n예) 상품 상태, 한정판 여부, 네고 가능 여부 등")
                        .applyNapzakFont(.body5SemiBold14)
                        .foregroundStyle(Color.napzakGrayScale(.gray200))
                        .padding(.leading, 12)
                        .padding(.vertical, 16)
                }
            }
            .frame(height: 136)
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.napzakGrayScale(.gray100), lineWidth: 1)
            }
            
            HStack(spacing: 0) {
                Spacer()
                Text(description.count.description)
                    .applyNapzakFont(.caption3Regular12)
                    .foregroundStyle(description.count == 0 ? Color.napzakGrayScale(.gray300) : Color.napzakGrayScale(.gray500))
                
                Text("/430")
                    .applyNapzakFont(.caption3Regular12)
                    .foregroundStyle(Color.napzakGrayScale(.gray300))
            }
            .frame(height: 13)
        }
    }
}
