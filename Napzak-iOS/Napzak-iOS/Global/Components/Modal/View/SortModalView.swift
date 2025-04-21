//
//  SortModalView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/21/25.
//

import SwiftUI

struct SortModalView: View {
    
    //MARK: - Property Wrappers
    
    @Binding var isSortModalPresented: Bool
    @Binding var selectedOption: SortOption
    
    //MARK: - Main Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        isSortModalPresented = false
                    }
                } label: {
                    Image(.iconCloseModal)
                }
            }
            
            ForEach(SortOption.allCases, id: \.self) { option in
                Button {
                    selectedOption = option
                    withAnimation {
                        isSortModalPresented = false
                    }
                } label: {
                    HStack(spacing: 8) {
                        Text("\(option.title)")
                            .applyNapzakFont(.body4Bold14)
                            .foregroundStyle(selectedOption == option ? Color.napzakPrimary(.purple500) : Color.napzakGrayScale(.gray300))
                        if selectedOption == option {
                            Image(.iconCheckSort)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 16)
                    .padding(.leading, 10)
                }
            }
        }
        .padding(.horizontal, 27)
        .padding(.top, 18)
        .padding(.bottom, 36)
        .background(Color.napzakGrayScale(.white))
        .clipShape(.rect(topLeadingRadius: 31, topTrailingRadius: 31))
    }
}

#Preview {
    struct PreviewContainer: View {
        @State private var isSortModalPresented = true
        @State private var selectedOption = SortOption.recent
        
        var body: some View {
            SortModalView(isSortModalPresented: $isSortModalPresented, selectedOption: $selectedOption)
        }
    }
    
    return PreviewContainer()
}
