//
//  FilterContainerView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/15/25.
//

import SwiftUI

struct FilterContainerView: View {
    
    //MARK: - Property Wrappers
    
    @Binding var selectedGenres: [String]
    @Binding var isUnopened: Bool?
    @Binding var isOnSale: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 6) {
            genreFilterChip
            if let isUnopened {
                unopenedFilterChip
            }
            onSaleFilterChip
        }
        .frame(height: 28)
        .frame(maxWidth: 255)
    }
    
    var genreFilterChip: some View {
        Button {
            if selectedGenres.isEmpty {
                selectedGenres = ["산리오", "d"]
            } else {
                selectedGenres = []
            }
        } label: {
            if selectedGenres.isEmpty {
                Image(.btnFilterGenre)
            } else {
                HStack(spacing: 0) {
                    Text("\(selectedGenres[0])")
                        .foregroundStyle(Color.napzakGrayScale(.white))
                        .applyNapzakFont(.caption1SemiBold12)
                        .truncationMode(.tail)
                    
                    if selectedGenres.count > 1 {
                        Text(" 외 \(selectedGenres.count - 1)")
                            .foregroundStyle(Color.napzakGrayScale(.white))
                            .applyNapzakFont(.caption1SemiBold12)
                    }
                    
                    Image(.iconArrowDownSelected)
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
            isUnopened?.toggle()
        } label: {
            if let isUnopened {
                Image(isUnopened ? .btnFilterUnopenedSelected : .btnFilterUnopened)
            }
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
        @State var selectedTabIndex = 0
        @State var selectedGenres = [String]()
        @State var isUnopened: Bool? = false
        @State var isOnSale = false

        var body: some View {
            FilterContainerView(selectedGenres: $selectedGenres, isUnopened: $isUnopened, isOnSale: $isOnSale)
        }
    }
    
    return PreviewContainer()
}

