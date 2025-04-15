//
//  NZSegmentedControl.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/15/25.
//

import SwiftUI

struct NZSegmentedControl: View {
    
    //MARK: - Property Wrappers
    
    @Binding var selectedTabIndex: Int
    
    //MARK: - Properties
    
    let tabs: [String]
    let spacing: CGFloat

    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: spacing), count: tabs.count)
    }
    
    //MARK: - Main Body
    
    var body: some View {
        VStack(spacing: 0) {
            segmentedButtons
                .padding(.vertical, 5)
            segmentedHighlighter
        }
    }
}

extension NZSegmentedControl {
    
    //MARK: - UI Properties
    
    private var segmentedButtons: some View {
        LazyVGrid(columns: columns) {
            ForEach(tabs.indices, id: \.self) { i in
                Button {
                    selectedTabIndex = i
                } label: {
                    Text(tabs[i])
                        .applyNapzakFont(selectedTabIndex == i ? .body1Bold16 : .body2SemiBold16)
                        .foregroundStyle(selectedTabIndex == i ? Color.napzakPrimary(.purple500): Color.napzakGrayScale(.gray200))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 36)
            }
        }
    }
    
    private var segmentedHighlighter: some View {
        LazyVGrid(columns: columns) {
            ForEach(tabs.indices, id: \.self) { i in
                Color.napzakPrimary(.purple500).opacity(selectedTabIndex == i ? 1 : 0)
                    .frame(height: 2)
            }
        }
    }
}

#Preview {
    struct PreviewContainer: View {
        @State var selectedTabIndex = 0
        
        var body: some View {
            NZSegmentedControl(selectedTabIndex: $selectedTabIndex, tabs: ["팔아요", "구해요"], spacing: 16)
        }
    }
    
    return PreviewContainer()
}
