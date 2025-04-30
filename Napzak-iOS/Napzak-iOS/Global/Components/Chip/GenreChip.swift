//
//  GenreChip.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/6/25.
//

import SwiftUI

struct GenreChip: View {
    
    let genre: GenreNameModel
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(genre.name)
                .applyNapzakFont(.caption1SemiBold12)
                .foregroundStyle(Color.napzakPrimary(.purple500))
                .lineLimit(1)
                .truncationMode(.tail)
                .padding(.leading, 10)
                .padding(.vertical, 6)
            
            Button {
                onDelete()
            } label: {
                Image(.iconCancleFilterchip)
            }
            .padding(.trailing, 6)
        }
        .frame(height: 28)
        .frame(maxWidth: 100)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.napzakPrimary(.purple500), lineWidth: 1)
        )
        .fixedSize(horizontal: true, vertical: false)
    }
}

#Preview {
    GenreChip(genre: GenreNameModel.sample  , onDelete: {})
}
