//
//  ChatMessageInputBar.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 6/30/25.
//

import SwiftUI

struct ChatMessageInputBar: View {
        
    @Binding var text: String
    @FocusState var isFocused: Bool
    
    let onSubmit: () -> Void
    
    var body: some View {
        HStack(spacing: 6) {
            ZStack(alignment: .center) {
                if text.isEmpty {
                    HStack {
                        Text("메시지를 입력하세요")
                            .foregroundColor(Color.napzakGrayScale(.gray200))
                            .font(.napzakFont(.body6Regular14))
                            .frame(height: 42)
                            .padding(.leading, 16)
                        Spacer()
                    }
                }

                TextEditor(text: $text)
                    .focused($isFocused)
                    .font(.napzakFont(.body6Regular14))
                    .foregroundColor(Color.napzakGrayScale(.black))
                    .frame(height: 42)
                    .frame(maxHeight: 120)
                    .padding(.top, 10)
                    .padding(.leading, 12)
                    .scrollContentBackground(.hidden)
            }
            
            Button {
                text = ""
                onSubmit()
            } label: {
                Image(!canSendMessage() ? .iconSendDisabled : .iconSendEnabled)
            }
            .disabled(!canSendMessage())
        }
        .padding(.trailing, 13)
        .frame(height: 42)
        .background(Color.napzakGrayScale(.gray50))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

private extension ChatMessageInputBar {
    
    //MARK: - private Func
    
    func canSendMessage() -> Bool {
        //띄어쓰기, 공백을 제외한 텍스트로 변환
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

#Preview {
    struct PreviewContainer: View {
        @State private var text: String = ""
        
        var body: some View {
            ChatMessageInputBar(
                text: $text,
                onSubmit: { }
            )
        }
    }
    
    return PreviewContainer()
        .padding(.horizontal, 20)
}
