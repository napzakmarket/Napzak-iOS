//
//  ChatImageMessage.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 6/30/25.
//

import SwiftUI

import Kingfisher

struct ChatImageMessage: View {
    
    //MARK: - Properties
    
    let imageUrl: String
    let onZoomButtonTapped: () -> Void
    
    //MARK: - Main Body
    
    var body: some View {
        Button {
            onZoomButtonTapped()
        } label: {
            ZStack(alignment: .bottomTrailing) {
                Group {
                    if let url = URL(string: imageUrl) {
                        KFImage(url)
                            .placeholder {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.napzakGrayScale(.gray100))
                            }
                            .retry(maxCount: 3, interval: .seconds(5))
                            .onFailure { error in
                                print("failure: \(error.localizedDescription)")
                            }
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.napzakGrayScale(.gray100))
                    }
                }
                .frame(width: 160, height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.napzakGrayScale(.gray100), lineWidth: 1)
                )
                Image(.imgZoom)
                    .padding([.trailing, .bottom], 10)
            }
        }
    }
}

#Preview {
    struct PreviewContainer: View {        
        var body: some View {
            ChatImageMessage(
                imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOrPQwOTaU_L8EIFpWzLjgiUHc3CcmGEq84A&s",
                onZoomButtonTapped: { }
            )
        }
    }
    
    return PreviewContainer()
}
