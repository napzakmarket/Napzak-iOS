//
//  VerificationHeaderView.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/25/26.
//

import SwiftUI

struct VerificationHeaderView: View {
    var body: some View {
        VStack(alignment: .leading ,spacing: 0) {
            Text("안전한 거래를 위해\n본인 확인을 진행해주세요")
                .lineLimit(2)
                .applyNapzakFont(.title2Bold20)
                .foregroundStyle(Color.napzakGrayScale(.gray400))
            
            Text("휴대폰 번호 1개당 1개의 계정만 이용 가능합니다.\n휴대폰 번호 변경은 지원하지 않습니다.")
                .applyNapzakFont(.caption3Regular12)
                .foregroundStyle(Color.napzakGrayScale(.gray300))
                .padding(.top, 10)
        }
    }
}

#Preview {
    VerificationHeaderView()
}
