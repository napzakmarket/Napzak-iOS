//
//  GenreItemView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/18/25.
//

import SwiftUI

struct GenreItemView: View {
    
    //MARK: - Properties
    
    let genreName: String
    
    //MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 6) {
                Text(genreName)
                    .applyNapzakFont(.caption1SemiBold12)
                    .foregroundColor(Color.napzakGrayScale(.gray500))
                    .padding(.leading, 28)
                Image(.imgGenreTag)
                Spacer()
                Image(.iconArrowRight)
                    .padding(.trailing, 28)
            }
            .background(Color.napzakGrayScale(.white))
            .frame(height: 60)
            
            Color.napzakGrayScale(.gray10)
                .frame(height: 4)
        }
    }
}

#Preview {
    GenreItemView(genreName: "산리오")
}
