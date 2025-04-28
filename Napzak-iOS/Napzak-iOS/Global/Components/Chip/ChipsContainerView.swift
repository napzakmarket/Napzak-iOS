//
//  ChipsContainerView.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/7/25.
//

import SwiftUI

struct ChipsContainerView: View {
    @Binding var selectedGenres: [GenreNameModel]
    
    var body: some View {
        HStack(spacing: 6) {
            Button {
                withAnimation {
                    selectedGenres.removeAll()
                }
            } label: {
                Image(.iconReset)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 5) {
                    ForEach(selectedGenres) { genre in
                        GenreChip(
                            genre: genre,
                            onDelete: {
                                withAnimation {
                                    removeGenre(genre)
                                }
                            }
                        )
                    }
                    .padding(.leading, 1)
                }
            }
        }
    }
}

extension ChipsContainerView {
    private func removeGenre(_ genre: GenreNameModel) {
        selectedGenres.removeAll { $0.id == genre.id }
    }
}

#Preview {
    struct PreviewContainer: View {
        @State private var genres = GenreNameModel.sampleGenreList
        
        var body: some View {
            ChipsContainerView(selectedGenres: $genres)
        }
    }
    
    return PreviewContainer()
        .padding(.horizontal, 20)
}
