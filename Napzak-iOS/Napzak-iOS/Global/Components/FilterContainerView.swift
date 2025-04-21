//
//  FilterContainerView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/15/25.
//

import SwiftUI

struct FilterContainerView: View {
    
    //MARK: - Property Wrappers
    
    @Binding var isGenreSelectModalPresented: Bool
    @Binding var selectedTabIndex: Int
    @Binding var selectedGenres: [GenreName]
    @Binding var isUnopened: Bool
    @Binding var isOnSale: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 6) {
            genreFilterChip
            if selectedTabIndex == 0 {
                unopenedFilterChip
            }
            onSaleFilterChip
            Spacer()
        }
        .frame(height: 28)
        .frame(maxWidth: 275)
    }
    
    var genreFilterChip: some View {
        Button {
            withAnimation {
                isGenreSelectModalPresented = true
            }
        } label: {
            if selectedGenres.isEmpty {
                Image(.btnFilterGenre)
            } else {
                HStack(spacing: 0) {
                    Text("\(selectedGenres[0].name)")
                        .foregroundStyle(Color.napzakGrayScale(.white))
                        .applyNapzakFont(.caption1SemiBold12)
                        .truncationMode(.tail)
                    
                    if selectedGenres.count > 1 {
                        Text(" 외 \(selectedGenres.count - 1)")
                            .foregroundStyle(Color.napzakGrayScale(.white))
                            .applyNapzakFont(.caption1SemiBold12)
                    }
                    
                    Image(.iconArrowDown)
                        .resizable()
                        .frame(width: 7, height: 4)
                        .padding(.leading, 4)
                }
                .frame(height: 28)
                .padding(.horizontal, 14)
                .background(Color.napzakGrayScale(.gray500))
                .clipShape(Capsule())
            }
        }
    }
    
    var unopenedFilterChip: some View {
        Button {
            isUnopened.toggle()
        } label: {
                Image(isUnopened ? .btnFilterUnopenedSelected : .btnFilterUnopened)
        }
    }

    var onSaleFilterChip: some View {
        Button {
            isOnSale.toggle()
        } label: {
            Image(isOnSale ? .btnFilterOnSaleSelected : .btnFilterOnSale)
        }
    }
}

#Preview {
    struct PreviewContainer: View {
        @State var isGenreSelectModalPresented = true
        @State var selectedTabIndex = 0
        @State var selectedGenres = [GenreName]()
        @State var isUnopened = false
        @State var isOnSale = false

        var body: some View {
            FilterContainerView(
                isGenreSelectModalPresented: $isGenreSelectModalPresented,
                selectedTabIndex: $selectedTabIndex,
                selectedGenres: $selectedGenres,
                isUnopened: $isUnopened,
                isOnSale: $isOnSale
            )
        }
    }
    
    return PreviewContainer()
}

