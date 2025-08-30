//
//  CustomToggleStyle.swift
//  Napzak-iOS
//
//  Created by 조호근 on 7/27/25.
//

import SwiftUI

struct CustomToggleStyle: ToggleStyle {
    
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            
            Spacer()
            
            ZStack {
                Capsule()
                    .fill(backgroundColor(for: configuration))
                    .frame(width: 48, height: 28)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 22, height: 22)
                    .offset(x: configuration.isOn ? 10 : -10)
                    .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
            }
            .onTapGesture {
                if isEnabled {
                    configuration.isOn.toggle()
                }
            }
        }
    }
    
    private func backgroundColor(for configuration: Configuration) -> Color {
        if isEnabled {
            if configuration.isOn {
                return Color.napzakPrimary(.purple500)
            } else {
                return Color.gray.opacity(0.4)
            }
        } else {
            if configuration.isOn {
                return Color.napzakPrimary(.purple200)
            } else {
                return Color.gray.opacity(0.4)
            }
        }
    }
}

#Preview {
    struct CustomToggleAllStatesPreview: View {
        @State private var isOn = true
        @State private var isOff = false
        
        var body: some View {
            VStack(alignment: .leading, spacing: 30) {
                
                VStack(alignment: .leading) {
                    Text("1. 활성화 (On)")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Toggle(isOn: $isOn) {
                        Text("앱 알림")
                            .applyNapzakFont(.body7Medium16)
                            .foregroundStyle(Color.napzakGrayScale(.gray400))
                    }
                    .toggleStyle(CustomToggleStyle())
                }
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text("2. 활성화 (Off)")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Toggle(isOn: $isOff) {
                        Text("앱 알림")
                            .applyNapzakFont(.body7Medium16)
                            .foregroundStyle(Color.napzakGrayScale(.gray400))
                    }
                    .toggleStyle(CustomToggleStyle())
                }
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text("3. 비활성화 (Disabled)")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Toggle(isOn: $isOn) {
                        Text("기기 알림이 꺼져있어요.")
                            .applyNapzakFont(.body7Medium16)
                            .foregroundStyle(Color.napzakState(.red).opacity(0.5))
                    }
                    .toggleStyle(CustomToggleStyle())
                    .disabled(true)
                }
            }
            .padding()
        }
    }
    
    return CustomToggleAllStatesPreview()
}

