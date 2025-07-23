//
//  PermissionModalView.swift
//  Napzak-iOS
//
//  Created by 조호근 on 7/14/25.
//

import SwiftUI

struct PermissionModalView: View {
    let state: PushOffState
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack(alignment: .top) {
                HStack {
                    Spacer()
                    
                    Button {
                        print("close")
                    } label: {
                        Image(.iconClose)
                    }
                    
                }
                .padding([.top, .trailing], 10)
                
                Image(.iconNotification)
                    .padding(.top, 31)
            }
            
            Text("기기 알림이 꺼져있어요!")
                .applyNapzakFont(.body1Bold16)
                .padding(.top, 17)
            
            Text("실시간 거래 알림을 받으려면\n설정을 변경해주세요.")
                .lineLimit(2)
                .applyNapzakFont(.caption1SemiBold12, lineSpacingEnabled: false)
                .foregroundStyle(Color.napzakGrayScale(.gray200))
                .multilineTextAlignment(.center)
                .padding(.top, 10)
                .frame(height: 40)
                
            Button {
                // TODO: - 권한설정에 따라 액션 처리
                switch state {
                case .appOnlyOff:
                    print("앱 알림 설정 화면으로 이동")
                case .osOnlyOff, .bothOff:
                    print("OS 설정 화면으로 이동")
                }
            } label: {
                Text("알림 켜기")
                    .applyNapzakFont(.body5SemiBold14)
                    .foregroundStyle(Color.napzakGrayScale(.white))
                    .frame(width: 232, height: 37)
                    .background(Color.napzakPrimary(.purple500))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.top, 15)
            .padding(.bottom, 24)
            
        }
        .background(Color.white)
        .cornerRadius(12)
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.5)
            .ignoresSafeArea()
        
        PermissionModalView(state: .appOnlyOff)
            .frame(width: 284, height: 290)
    }
}
