//
//  FilterContainerView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/15/25.
//

import SwiftUI

struct FilterContainerView: View {
    
    enum Style { case standard, market }
    var style: Style = .standard
    
    //MARK: - Property Wrappers
    
    @Binding var isGenreSelectModalPresented: Bool
    @Binding var selectedTabIndex: Int
    @Binding var selectedGenres: [GenreNameModel]
    @Binding var isUnopened: Bool
    @Binding var isOnSale: Bool
    
    enum AppImage: String {
        case btnOnSale = "btn_onsale"
        case btnOnSalePurple = "btn_onsale_purple"
        case btnGetting = "btn_getting"
        case btnGettingPurple = "btn_getting_purple"
        
        var image: Image {
            Image(self.rawValue)
        }
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 6) {
            genreFilterChip

            if style == .market {
                activeStatusFilterChip
            } else {
                if selectedTabIndex == 0 {
                    unopenedFilterChip
                }
                onSaleFilterChip

                if selectedTabIndex == 1 {
                    Color.clear.frame(width: 60)
                }
            }

            Spacer()
        }
        .frame(height: 28)
        .frame(maxWidth: 270)
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
    
    var activeStatusFilterChip: some View {
        Button {
            isOnSale.toggle()
        } label: {
            Image(
                selectedTabIndex == 0
                ? (isOnSale ? AppImage.btnOnSalePurple.rawValue : AppImage.btnOnSale.rawValue)
                : (isOnSale ? AppImage.btnGettingPurple.rawValue : AppImage.btnGetting.rawValue)
            )
            .renderingMode(.original)
        }
    }

}

#Preview {
    struct PreviewContainer: View {
        @State var isGenreSelectModalPresented = true
        @State var selectedTabIndex = 0
        @State var selectedGenres = [GenreNameModel]()
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

