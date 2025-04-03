//
//  CheckRow.swift
//  Napzak-iOS
//
//  Created by 조호근 on 3/27/25.
//

import SwiftUI

struct CheckRow: View {
    let title: String
    @Binding var isAgreed: Bool
    var rowType: RowType = .none
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
            
            if rowType == .arrow {
                Button {
                    action?()
                } label: {
                    Image(.iconGo)
                }.padding(.trailing, 10)
            }
        }
        .frame(height: 50)
        .background(rowType == .background ? Color.napzakGrayScale(.gray50) : nil)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    CheckRow(title: "약관 전체 동의", isAgreed: .constant(true), rowType: .background)
}
