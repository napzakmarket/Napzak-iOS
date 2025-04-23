//
//  SearchChipContainerView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/23/25.
//

import SwiftUI

struct SearchChipContainerView: View {
    
    //MARK: - Property Wrappers
    
    @State var totalHeight: CGFloat = .zero
    
    //MARK: - Properties

    let titles: [String]
    let action: (String) -> Void
    
    let horizontalSpacing: CGFloat = 6
    let verticalSpacing: CGFloat = 8
    
    var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        GeometryReader { geomety in
            ZStack(alignment: .topLeading) {
                ForEach(titles, id: \.self) { title in
                    Button {
                        action(title)
                    } label: {
                        SearchChip(title: title)
                    }
                    .alignmentGuide(.leading) { view in
                        if abs(width - view.width) > geomety.size.width {
                            width = 0
                            height -= view.height
                            height -= verticalSpacing
                        }
                        let result = width
                        
                        if title == titles.last {
                            width = 0
                        } else {
                            width -= view.width
                            width -= horizontalSpacing
                        }
                        
                        return result
                    }
                    .alignmentGuide(.top) { _ in
                        let result = height
                        
                        if title == titles.last {
                            height = 0
                        }
                        return result
                    }
                }
            }
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            self.totalHeight = geometry.size.height
                        }
                }
            )
        }
        .frame(height: totalHeight)
        .padding(.leading, 1)
    }
}

#Preview {
    SearchChipContainerView(
        titles: [
            "헌터x헌터 룩업",
            "주술회전 고죠 사토루",
            "웨딩 마이멜로디",
            "짱구는 못말려 날아라 수제김밥",
            "은혼 긴토키",
            "하이큐 모찌모찌 마스코트",
            "하이큐 모찌모찌 마스코투"
        ],
        action: { title in
            print(title)
        }
    )
}
