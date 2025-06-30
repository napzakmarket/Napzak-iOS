//
//  ChatBubble.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 6/30/25.
//

import SwiftUI

struct ChatBubble: View {
        
    let message: String
    let isReceived: Bool
    
    var body: some View {
        Text(message)
            .applyNapzakFont(.body6Regular14)
            .foregroundStyle(isReceived ? Color.napzakGrayScale(.black) : Color.napzakGrayScale(.white))
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(isReceived ? Color.napzakGrayScale(.gray50) : Color.napzakPrimary(.purple500))
            .clipShape(SelectiveCornerRadius(
                topLeft: isReceived ? 2 : 16,
                topRight: isReceived ? 16 : 2,
                bottomLeft: 16,
                bottomRight: 16
            ))
    }
}

#Preview {
    struct PreviewContainer: View {
        var body: some View {
            ChatBubble(
                message: "뭐야\n가세요';;;;",
                isReceived: false
            )
        }
    }
    
    return PreviewContainer()
        .padding(.horizontal, 20)
}
