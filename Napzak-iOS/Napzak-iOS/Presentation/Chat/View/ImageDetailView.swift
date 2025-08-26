//
//  ImageDetailView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 7/22/25.
//

import SwiftUI

import Kingfisher
import Zoomable

enum ImageDetailViewType {
    case plain
    case beforeSendImage
}

struct ImageDetailView: View {
    
    //MARK: - Property Wrappers
    
    @Binding var isImageDetailViewPresent: Bool
    
    //MARK: - Properties
    
    let imageUrl: String
    var viewType: ImageDetailViewType = .plain
    var onSendButtonTapped: () -> Void = { }
    
    //MARK: - Main Body
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.napzakGrayScale(.black)
            VStack {
                Spacer()
                if let url = URL(string: imageUrl) {
                    KFImage(url)
                        .resizable()
                        .zoomable()
                        .aspectRatio(contentMode: .fit)
                }
                Spacer()
            }
            HStack {
                closeButton
                if viewType == .beforeSendImage {
                    Spacer()
                    sendButton
                }
            }
            .padding(.top, 50)
            .padding(.horizontal, 20)
        }
        .ignoresSafeArea()
    }
}

private extension ImageDetailView {
    
    //MARK: - UI Properties
    
    var sendButton: some View {
        Button {
            isImageDetailViewPresent = false
            onSendButtonTapped()
        } label: {
            Image(.btnSend)
        }
    }
    
    var closeButton: some View {
        Button {
            isImageDetailViewPresent = false
        } label: {
            Image(viewType == .plain ? .iconClose : .iconBack)
                .frame(width: 24, height: 24)
        }
    }
}
