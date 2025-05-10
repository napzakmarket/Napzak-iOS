//
//  SettingView.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/11/25.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        VStack(spacing: 0){
            SettingViewHeader
            
            Spacer()
        }
        .ignoresSafeArea()
        
    }
}

extension SettingView {
    private var SettingViewHeader: some View {
        VStack(alignment: .leading) {
            Button {
                //Todo: - 네비게이션 pop
                print("backButton tapped")
            } label: {
                HStack(alignment: .center, spacing: 0) {
                    Image(.iconBack)
                        .padding(.trailing,4)
                        .frame(width: 24, height: 24)
                    Text("설정")
                        .applyNapzakFont(.body1Bold16)
                        .foregroundStyle(Color.napzakGrayScale(.gray400))
                        .frame(height: 20)
                }
            }
            .padding(.top, 58)
            .padding(.bottom, 18)
            .padding(.leading, 20)
            
            Divider()
        }
        .frame(height: 100)
    }
}

#Preview {
    SettingView()
}
