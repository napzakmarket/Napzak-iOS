//
//  OnboardingTermsView.swift
//  Napzak-iOS
//
//  Created by 조호근 on 3/26/25.
//

import SwiftUI

struct OnboardingTermsView: View {
    @State private var isAllAgreed: Bool = false
    @State private var isTermsAgreed: Bool = false
    @State private var isPrivacyAgreed: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            OnboardingNavigationBar(step: 1)
                .frame(height: 48)
            
            Text("서비스 이용약관에 동의해주세요")
                .applyNapzakFont(.title2Bold20)
                .foregroundColor(Color.napzakGrayScale(.gray400))
                .padding([.leading, .top], 20)
            
            Group {
                CheckRow(
                    title: "약관 전체 동의",
                    isAgreed: $isAllAgreed,
                    rowType: .background
                )
                .padding(.top, 30)
                
                CheckRow(
                    title: "(필수) 이용약관",
                    isAgreed: $isTermsAgreed,
                    rowType: .arrow
                ) {
                    // TODO: 이용약관 외부 링크로 이동 처리
                    
                    print("이용약관 외부 링크 이동")
                }
                .padding(.top, 10)
                
                CheckRow(
                    title: "(필수) 개인정보처리방침",
                    isAgreed: $isPrivacyAgreed,
                    rowType: .arrow
                ) {
                    // TODO: 개인정보처리방침 외부 링크로 이동 처리
                    
                    print("개인정보처리방침 외부 링크 이동")
                }
                
                Spacer()
                
                PrimaryButton(
                    title: "다음으로",
                    isEnabled: isAllAgreed
                ) {
                    // TODO: 다음 화면으로 이동 (ex. 닉네임 입력 화면)
                    
                    print("다음으로")
                }
                .padding(.bottom, 75)
            }
            .padding(.horizontal, 20)
        }
        .onChange(of: isAllAgreed) { newValue in
            updateAllAgreeState(newValue)
        }
        .onChange(of: isTermsAgreed) { _ in
            updateAllAgreeState()
        }
        .onChange(of: isPrivacyAgreed) { _ in
            updateAllAgreeState()
        }
    }
}

extension OnboardingTermsView {
    
    private func updateAllAgreeState() {
        isAllAgreed = isTermsAgreed && isPrivacyAgreed
    }
    
    private func updateAllAgreeState(_ isChecked: Bool) {
        if isChecked {
            isTermsAgreed = true
            isPrivacyAgreed = true
        } else {
            if isTermsAgreed && isPrivacyAgreed {
                isTermsAgreed = false
                isPrivacyAgreed = false
            }
        }
    }
    
}

#Preview {
    OnboardingTermsView()
}
