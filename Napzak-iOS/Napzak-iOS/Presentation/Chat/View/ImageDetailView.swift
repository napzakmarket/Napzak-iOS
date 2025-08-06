//
//  ImageDetailView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 7/22/25.
//

import SwiftUI

import Kingfisher

struct ImageDetailView: View {
    
    //MARK: - Property Wrappers
    
    @Binding var isImageDetailViewPresent: Bool
    
    //MARK: - Properties
    
    let imageUrl: String
    
    //MARK: - Main Body
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.napzakGrayScale(.black)
            ZoomableImageView(imageUrl: URL(string: imageUrl)!)
            closeButton
        }
        .ignoresSafeArea()
    }
}

private extension ImageDetailView {
    
    //MARK: - UI Properties
    
    var closeButton: some View {
        Button {
            isImageDetailViewPresent = false
        } label: {
            Image(.iconClose)
                .frame(width: 48, height: 48)
        }
        .padding(.top, 40)
        .padding(.trailing, 20)
    }
}
