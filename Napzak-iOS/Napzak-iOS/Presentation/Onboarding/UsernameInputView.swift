//
//  UsernameInputView.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/1/25.
//

import SwiftUI

struct UsernameInputView: View {
    @State private var isNextButtonEnabled: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            OnboardingNavigationBar(step: 2)
            
            Group {
                Text("납작마켓에서 사용할 이름을 알려주세요")
                    .lineLimit(2)
                    .applyNapzakFont(.title2Bold20)
                    .foregroundStyle(Color.napzakGrayScale(.gray400))
                    .frame(width: 162)
                    .padding(.top, 20)
                
                Text("띄어쓰기 없이 한글, 영문, 숫자만 사용할 수 있어요 (최대 20자)")
                    .applyNapzakFont(.caption3Regular12)
                    .foregroundStyle(Color.napzakGrayScale(.gray300))
                    .padding(.top, 10)
                
                UsernameInputField(isPrimaryButtonEnabled: $isNextButtonEnabled)
                    .padding(.top, 30)
                
                Spacer()
                
                PrimaryButton(
                    title: "다음으로",
                    isEnabled: isNextButtonEnabled
                ) {
                    // TODO: 다음 화면으로 이동 (ex. 관심 장르 선택)
                    
                    print("다음으로")
                }
                .padding(.bottom, 75)
                
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    UsernameInputView()
}
