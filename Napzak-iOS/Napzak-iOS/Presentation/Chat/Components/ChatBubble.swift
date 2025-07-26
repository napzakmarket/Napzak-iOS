//
//  ChatBubble.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 6/30/25.
//

import SwiftUI

struct ChatBubble: View {
        
    let message: String
    let isMessageOwner: Bool
    
    var body: some View {
        Text(message)
            .applyNapzakFont(.body6Regular14)
            .foregroundStyle(isMessageOwner ? Color.napzakGrayScale(.white) : Color.napzakGrayScale(.black))
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(isMessageOwner ? Color.napzakPrimary(.purple500) : Color.napzakGrayScale(.gray50))
            .clipShape(RoundedCornerShape(
                topLeft: isMessageOwner ? 16 : 2,
                topRight: isMessageOwner ? 2 : 16,
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
                isMessageOwner: false
            )
        }
    }
    
    return PreviewContainer()
        .padding(.horizontal, 20)
}
