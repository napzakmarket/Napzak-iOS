//
//  ChatDateDivider.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 6/30/25.
//

import SwiftUI

struct ChatDateDivider: View {
    
    //MARK: - Properties
    
    let date: String
    
    //MARK: - Main Body
    
    var body: some View {
        ZStack(alignment: .center) {
            Image(.imgDateDivider)
            Text(date)
                .applyNapzakFont(.caption3Regular12)
                .foregroundStyle(Color.napzakGrayScale(.gray200))
        }
    }
}

#Preview {
    struct PreviewContainer: View {
        var body: some View {
            ChatDateDivider(
                date: "2025년 12월 31일"
            )
        }
    }
    
    return PreviewContainer()
}
