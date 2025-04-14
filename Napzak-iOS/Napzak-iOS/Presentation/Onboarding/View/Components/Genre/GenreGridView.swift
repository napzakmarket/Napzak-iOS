//
//  GenreGridView.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/7/25.
//

import SwiftUI

struct GenreGridView: View {
    @Binding var genres: [PreferGenre]
    @Binding var selectedGenres: [PreferGenre]
    let onGenreSelected: (PreferGenre) -> Void
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(genres) { genre in
                    GenreCell(
                        genre: genre,
                        isSelected: isGenreSelected(genre)
                    )
                    .onTapGesture {
                        onGenreSelected(genre)
                    }
                }
            }
            .padding(.top, 10)
        }
    }
}

extension GenreGridView {
    private func isGenreSelected(_ genre: PreferGenre) -> Bool {
        return selectedGenres.contains { $0.id == genre.id }
    }
}

#Preview {
    GenreGridView(genres: .constant(PreferGenreData.sample.genreList), selectedGenres: .constant(Array(PreferGenreData.sample.genreList.prefix(3))), onGenreSelected: {_ in })
}
