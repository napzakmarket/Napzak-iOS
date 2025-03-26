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
                TermsAgreeRow(
                    title: "약관 전체 동의",
                    isAgreed: $isAllAgreed,
                    hasArrow: false
                )
                .padding(.top, 30)
                
                TermsAgreeRow(
                    title: "(필수) 이용약관",
                    isAgreed: $isTermsAgreed
                ) {
                    print("이용약관 외부 링크 이동")
                }
                .padding(.top, 10)
                
                TermsAgreeRow(
                    title: "(필수) 개인정보처리방침",
                    isAgreed: $isPrivacyAgreed
                ) {
                    print("개인정보처리방침 외부 링크 이동")
                }
                
                Spacer()
                
                PrimaryButton(
                    title: "다음으로",
                    isEnabled: isAllAgreed
                ) {
                    print("다음으로")
                }
                .padding(.bottom, 75)
            }
            .padding(.horizontal, 20)
        }
        .onChange(of: isAllAgreed) { _, newValue in
            if newValue {
                isTermsAgreed = true
                isPrivacyAgreed = true
            } else {
                if isTermsAgreed && isPrivacyAgreed {
                    isTermsAgreed = false
                    isPrivacyAgreed = false
                }
            }
        }
        .onChange(of: isTermsAgreed) { _, _ in
            updateAllAgreeState()
        }
        .onChange(of: isPrivacyAgreed) { _, _ in
            updateAllAgreeState()
        }
    }
}

extension OnboardingTermsView {
    
    private func updateAllAgreeState() {
        isAllAgreed = isTermsAgreed && isPrivacyAgreed
    }
    
}

#Preview {
    OnboardingTermsView()
}
