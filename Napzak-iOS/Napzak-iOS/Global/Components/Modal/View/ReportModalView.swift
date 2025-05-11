//
//  ReportModalView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 5/7/25.
//

import SwiftUI

struct ReportModalView: View {
    
    //MARK: - Property Wrappers
    
    @Binding var isReportModalPresented: Bool
    
    //MARK: - Properties
    
    let reportType: ReportType
    
    //MARK: - Main Body
    
    var body: some View {
        VStack(alignment: .center, spacing: 34) {
            Capsule()
                .fill(Color.napzakGrayScale(.gray100))
                .frame(width: 42, height: 2)
            
            Button {
                withAnimation {
                    isReportModalPresented = false
                }
            } label: {
                HStack(spacing: 6) {
                    Image(.imgReportModal)
                    Text("\(reportType.title) 신고하기")
                        .applyNapzakFont(.body4Bold14)
                        .foregroundStyle(Color.napzakState(.red))
                    Spacer()
                }
                .padding(.vertical, 10)
            }
        }
        .padding(.top, 17)
        .padding(.horizontal, 28)
        .padding(.bottom, 53)
        .background(Color.napzakGrayScale(.white))
        .clipShape(.rect(topLeadingRadius: 31, topTrailingRadius: 31))
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.height > 60 {
                        withAnimation {
                            isReportModalPresented = false
                        }
                    }
                }
        )
    }
}

#Preview {
    struct PreviewContainer: View {
        @State private var isViewerOptionsPresented = true
        
        var body: some View {
            ReportModalView(
                isReportModalPresented: $isViewerOptionsPresented,
                reportType: .product
            )
        }
    }
    
    return PreviewContainer()
}
