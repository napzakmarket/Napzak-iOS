//
//  AppAlertView.swift
//  Napzak-iOS
//
//  Created by 조호근 on 8/21/25.
//

import SwiftUI

struct AppAlertView: View {
    enum Style {
        case update
        case banned
        
        var icon: Image {
            switch self {
            case .update: return Image(.iconUpdate)
            case .banned: return Image(.iconBanned)
            }
        }
        
        var title: String {
            switch self {
            case .update: return "업데이트가 필요해요!"
            case .banned: return "접근이 불가합니다."
            }
        }
        
        var message: String {
            switch self {
            case .update: return "원활한 서비스 이용을 위해\n최신 버전으로 업데이트해주세요."
            case .banned: return "서비스 운영 정책에 따라\n현재 계정은 이용이 제한된 상태입니다."
            }
        }
        
        var napzakEmail: String? {
            switch self {
            case .update: return nil
            case .banned: return "napzakmarket@gmail.com"
            }
        }
        
        var buttonTitle: String {
            switch self {
            case .update: return "납작마켓 업데이트"
            case .banned: return "확인"
            }
        }
        
        var buttonColor: Color {
            switch self {
            case .update: return Color.napzakPrimary(.purple500)
            case .banned: return Color.napzakState(.red)
            }
        }
    }
    
    let style: Style
    let onConfirm: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            style.icon
                .padding(.top, 24)
            
            Text(style.title)
                .applyNapzakFont(.body1Bold16)
                .padding(.top, 12)
            
            Group {
                Text(style.message)
                    .padding(.top, 10)
                
                if let email = style.napzakEmail {
                    HStack(alignment: .center, spacing: 0) {
                        Text("관련 문의: ")
                        
                        Text(email)
                            .underline()
                            .onTapGesture {
                                UIPasteboard.general.string = email
                            }
                    }
                }
            }
            .multilineTextAlignment(.center)
            .applyNapzakFont(.caption1SemiBold12, lineSpacingEnabled: false)
            .foregroundStyle(Color.napzakGrayScale(.gray200))
            
            Button {
                onConfirm()
            } label: {
                HStack(spacing: 10) {
                    Text(style.buttonTitle)
                        .applyNapzakFont(.body5SemiBold14)
                        .foregroundStyle(.white)
                        
                    
                    if style == .update {
                        Image(.iconNext)
                    }
                }
                .frame(height: 37)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(style.buttonColor)
                )
            }
            .padding(.top, 13)
            .padding(.bottom, 24)
            .padding(.horizontal, 26)
        }
        .background(Color.white)
        .cornerRadius(12)

    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.5)
            .ignoresSafeArea()
        AppAlertView(style: .banned, onConfirm: {})
            .frame(width: 284)
    }
}
