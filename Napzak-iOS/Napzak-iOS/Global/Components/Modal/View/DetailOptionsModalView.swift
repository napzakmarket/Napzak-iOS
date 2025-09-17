//
//  DetailOptionModalView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 5/7/25.
//

import SwiftUI

enum DetailOptionType {
    case chat(isBlocked: Bool)
    case store(isBlocked: Bool)
    case product

    var reportTitle: String {
        switch self {
        case .chat, .store:
            return "마켓"
        case .product:
            return "상품"
        }
    }
    
    var isBlocked: Bool {
        switch self {
        case .chat(let isBlocked), .store(let isBlocked):
            return isBlocked
        case .product:
            return false
        }
    }
}

struct DetailOptionsModalView: View {
    
    //MARK: - Property Wrappers
    
    @Binding var isReportModalPresented: Bool
    
    //MARK: - Properties
    
    let type: DetailOptionType
    let onReportButtonTapped: () -> Void
    var onBlockButtonTapped: () -> Void = { }
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
                    Text("\(type.reportTitle) 신고하기")
                        .applyNapzakFont(.body4Bold14)
                        .foregroundStyle(Color.napzakState(.red))
                    Spacer()
                }
                .padding(.vertical, 10)
            }
            
            switch type {
            case .chat(let isBlocked):
                blockButton(isBlocked)
                Button {
                    withAnimation {
                        isReportModalPresented = false
                        onExitButtonTapped()
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
            case .store(let isBlocked):
                blockButton(isBlocked)
            case .product:
                EmptyView()
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

extension DetailOptionsModalView {
    
    @ViewBuilder
    func blockButton(_ isBlocked: Bool) -> some View {
        Button {
            withAnimation {
                isReportModalPresented = false
                onBlockButtonTapped()
            }
        } label: {
            HStack(spacing: 6) {
                Image(isBlocked ? .imgUnblockModal : .imgBlockModal)
                Text(isBlocked ? "마켓 차단 해제하기" : "마켓 차단하기")
                    .applyNapzakFont(.body4Bold14)
                    .foregroundStyle(Color.napzakGrayScale(.gray500))
                Spacer()
            }
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    struct PreviewContainer: View {
        @State private var isViewerOptionsPresented = true
        
        var body: some View {
            DetailOptionsModalView(
                isReportModalPresented: $isViewerOptionsPresented,
                type: .chat(isBlocked: true),
                onReportButtonTapped: { },
                onExitButtonTapped: { }
            )
        }
    }
    
    return PreviewContainer()
}
