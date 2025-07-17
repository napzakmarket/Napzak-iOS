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
    var isUsedInChat: Bool = false
    let onReportButtonTapped: () -> Void
    var onExitButtonTapped: () -> Void = { }
    
    //MARK: - Main Body
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Capsule()
                .fill(Color.napzakGrayScale(.gray100))
                .frame(width: 42, height: 2)
                .padding(.bottom, 34)

            Button {
                withAnimation {
                    isReportModalPresented = false
                    onReportButtonTapped()
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
            
            if isUsedInChat {
                Button {
                    withAnimation {
                        isReportModalPresented = false
                        onReportButtonTapped()
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(.imgExitModal)
                        Text("채팅방 나가기")
                            .applyNapzakFont(.body4Bold14)
                            .foregroundStyle(Color.napzakState(.red))
                        Spacer()
                    }
                    .padding(.vertical, 10)
                }
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
                reportType: .product,
                isUsedInChat: true,
                onReportButtonTapped: { },
                onExitButtonTapped: { }
            )
        }
    }
    
    return PreviewContainer()
}
