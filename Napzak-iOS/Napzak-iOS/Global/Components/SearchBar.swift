//
//  SearchBar.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/6/25.
//

import SwiftUI

struct SearchBar: View {
    
    let placeholder: String
    var cornerRadius: CGFloat = 14
    
    @Binding var text: String
    @Binding var isCompleted: Bool
    @FocusState var isFocused: Bool
    
    var onSearchButtonTapped: () -> Void = { }
    var onSubmit: () -> Void = { }
    
    var body: some View {
        HStack(spacing: 6) {
            TextField(
                "placeholder",
                text: $text,
                prompt: Text(placeholder)
                    .foregroundColor(Color.napzakGrayScale(.gray200))
                    .font(.napzakFont(.caption2Medium12))
            )
            .applyNapzakFont(.caption1SemiBold12)
            .foregroundStyle(Color.napzakGrayScale(.gray500))
            .focused($isFocused)
            .tint(Color.napzakGrayScale(.gray500))
            .onSubmit {
                isCompleted = true
                onSubmit()
            }
            
            HStack(spacing: 0) {
                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(.iconSearchCancle)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
                
                Button {
                    if text.isEmpty {
                        isFocused = true
                    } else {
                        print("돋보기 Tapped: \(text)")
                        isFocused = false
                        isCompleted = true
                        onSearchButtonTapped()
                    }
                } label: {
                    Image(.iconSearch)
                }
            }
        }
        .padding(.leading, 16)
        .padding(.trailing, 10)
        .frame(height: 39)
        .background(Color.napzakGrayScale(.gray50))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .animation(.easeInOut(duration: 0.3), value: text.isEmpty)
    }
}

#Preview {
    struct PreviewContainer: View {
        @State private var text: String = ""
        @State private var isCompleted: Bool = false
        
        var body: some View {
            SearchBar(
                placeholder: "원하는 장르를 직접 검색해보세요",
                text: $text,
                isCompleted: $isCompleted
            )
        }
    }
    
    return PreviewContainer()
        .padding(.horizontal, 20)
}
