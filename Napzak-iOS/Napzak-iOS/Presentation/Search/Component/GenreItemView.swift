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
        HStack(alignment: .center, spacing: 6) {
            Text(genreName)
                .applyNapzakFont(.body5SemiBold14)
                .foregroundColor(Color.napzakGrayScale(.gray500))
                .padding(.leading, 28)
            Image(.imgGenreTag)
            Spacer()
            Image(.iconArrowRight)
                .padding(.trailing, 28)
        }
        .frame(height: 60)
        .background(Color.napzakGrayScale(.white))
    }
}

#Preview {
    GenreItemView(genreName: "산리오")
}
