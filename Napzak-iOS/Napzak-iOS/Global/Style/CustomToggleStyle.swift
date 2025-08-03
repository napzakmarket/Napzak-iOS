//
//  CustomToggleStyle.swift
//  Napzak-iOS
//
//  Created by 조호근 on 7/27/25.
//

import SwiftUI

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            
            Spacer()
            
            ZStack {
                Capsule()
                    .fill(configuration.isOn ? Color.napzakPrimary(.purple500) : Color.gray.opacity(0.4))
                    .frame(width: 48, height: 28)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 22, height: 22)
                    .offset(x: configuration.isOn ? 10 : -10)
                    .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
            }
            .onTapGesture {
                configuration.isOn.toggle()
            }
        }
    }
}

#Preview {
    struct CustomTogglePreview: View {
        @State private var isOn = false
        
        var body: some View {
            Toggle(isOn: $isOn) {
                Text(isOn ? "앱 알림" : "기기 알림이 꺼져있어요.")
                    .applyNapzakFont(.body7Medium16)
                    .foregroundStyle(isOn ? Color.napzakGrayScale(.gray400) : Color.napzakState(.red))
                    .frame(height: 20)
            }
            .toggleStyle(CustomToggleStyle())
            .padding()
        }
    }
    
    return CustomTogglePreview()
}

