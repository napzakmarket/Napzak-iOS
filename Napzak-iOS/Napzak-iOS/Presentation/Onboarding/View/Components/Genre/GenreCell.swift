//
//  GenreCell.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/6/25.
//

import SwiftUI
import Kingfisher

struct GenreCell: View {
    
    let genre: PreferGenreModel
    var isSelected: Bool
    
    var body: some View {
        VStack(spacing: 7) {
            imageView
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            
            Text(genre.name)
                .applyNapzakFont(
                    isSelected ? .caption1SemiBold12 : .caption3Regular12)
                .foregroundStyle(
                    isSelected ? Color.napzakPrimary(.purple500) : Color.napzakGrayScale(.gray300))
        }
    }
}

extension GenreCell {
    private var imageView: some View {
        ZStack() {
            if let imageURL = genre.image,
               let url = URL(string: imageURL) {
                KFImage(url)
                    .placeholder {
                        Circle()
                            .fill(Color.napzakGrayScale(.gray100))
                    }.retry(maxCount: 3, interval: .seconds(3))
                    .onFailure { error  in
                        print("failure: \(error.localizedDescription)")
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    
            } else {
                Circle()
                    .fill(Color.napzakGrayScale(.gray100))
            }
            
            if isSelected {
                Image(.overlayLike)
            }
        }
    }
}

#Preview {
    struct PreviewContainer: View {
        var isSelected: Bool = false
        
        var body: some View {
            GenreCell(genre: PreferGenreModel.sample, isSelected: isSelected)
        }
    }
    
    return PreviewContainer()
}
