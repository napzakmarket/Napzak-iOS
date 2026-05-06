//
//  VerificationBottomActionView.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/25/26.
//

import SwiftUI

struct VerificationBottomActionView: View {
    @Binding var isChecked: Bool
    let isNextEnabled: Bool
    let onTapNext: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            agreementView
            nextButton
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(Color.white)
    }
}

extension VerificationBottomActionView {
    private var agreementView: some View {
        HStack(alignment: .center, spacing: 8) {
            Button {
                isChecked.toggle()
            } label: {
                
                Image(isChecked ? .checkboxSelected : .checkboxDefault )
                
            }
            
            Text("(필수) 만 14세 이상이에요")
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(Color.napzakGrayScale(.gray400))
        }
    }

    private var nextButton: some View {
        Button {
            onTapNext()
        } label: {
            HStack(alignment: .center, spacing: 4) {
                Text("다음으로")
                    .applyNapzakFont(.body4Bold14)
                    .foregroundStyle(.white)
            }
            .foregroundStyle(
                isNextEnabled
                ? Color.white
                : Color.napzakGrayScale(.gray200)
            )
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                isNextEnabled
                ? Color.napzakPrimary(.purple500)
                : Color.napzakGrayScale(.gray100)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .disabled(!isNextEnabled)
    }
}

#Preview("비활성 상태") {
    VerificationBottomActionView(
        isChecked: .constant(false),
        isNextEnabled: false,
        onTapNext: {}
    )
}

#Preview("체크됨 + 비활성 상태") {
    VerificationBottomActionView(
        isChecked: .constant(true),
        isNextEnabled: false,
        onTapNext: {}
    )
}

#Preview("활성 상태") {
    VerificationBottomActionView(
        isChecked: .constant(true),
        isNextEnabled: true,
        onTapNext: {}
    )
}
