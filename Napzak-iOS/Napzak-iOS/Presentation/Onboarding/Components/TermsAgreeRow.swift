//
//  TermsAgreeRow.swift
//  Napzak-iOS
//
//  Created by 조호근 on 3/27/25.
//

import SwiftUI

struct TermsAgreeRow: View {
    let title: String
    @Binding var isAgreed: Bool
    var hasArrow: Bool = true
    var action: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Button {
                isAgreed.toggle()
            } label: {
                Image(isAgreed ? .checkboxSelected : .checkboxDefault)
            }.padding(.leading, 10)
            
            Text(title)
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(Color.napzakGrayScale(.gray400))
            
            Spacer()
            
            if hasArrow {
                Button {
                    action?()
                } label: {
                    Image(.iconGo)
                }.padding(.trailing, 10)
            }
        }
        .frame(height: 50)
        .background(hasArrow ? nil : Color.napzakGrayScale(.gray50))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    TermsAgreeRow(title: "약관 전체 동의", isAgreed: .constant(true), hasArrow: true)
}
