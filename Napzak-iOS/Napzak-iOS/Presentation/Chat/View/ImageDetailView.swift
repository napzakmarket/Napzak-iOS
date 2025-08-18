//
//  ImageDetailView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 7/22/25.
//

import SwiftUI

import Kingfisher
import Zoomable

struct ImageDetailView: View {
    
    //MARK: - Property Wrappers
    
    @Binding var isImageDetailViewPresent: Bool
    
    //MARK: - Properties
    
    let imageUrl: String
    
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
