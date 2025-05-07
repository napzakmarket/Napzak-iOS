//
//  ProductOwnerOptionsModalView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 5/7/25.
//

import SwiftUI

struct ProductOwnerOptionsModalView: View {
    
    //MARK: - Property Wrappers
    
    @State private var isChangeStatusButtonSelected = false
    
    @Binding var isOwnerOptionsModalPresented: Bool
    @Binding var currentStatus: TradeStatus
    
    //MARK: - Properties
    
    let tradeType: TradeType
    private let tradeStatuses = TradeStatus.allCases
    
    //MARK: - Main Body
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Capsule()
                .fill(Color.napzakGrayScale(.gray100))
                .frame(width: 42, height: 2)
            
            editButton
            changeStatusButton
            if isChangeStatusButtonSelected {
                tradeStatusDetailButtons
            }
            deleteButton
            Spacer()
        }
        .frame(height: 380)
        .padding(.top, 17)
        .padding(.horizontal, 28)
        .background(Color.napzakGrayScale(.white))
        .clipShape(.rect(topLeadingRadius: 31, topTrailingRadius: 31))
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.height > 60 {
                        withAnimation {
                            isOwnerOptionsModalPresented = false
                        }
                    }
                }
        )
    }
}

private extension ProductOwnerOptionsModalView {
    
    //MARK: - UI Properties
    
    var editButton: some View {
        Button {
            withAnimation {
                isOwnerOptionsModalPresented = false
            }
            isChangeStatusButtonSelected = false
        } label: {
            HStack(spacing: 6) {
                Image(.imgEditModal)
                Text("상품 수정")
                    .applyNapzakFont(.body4Bold14)
                    .foregroundStyle(Color.napzakGrayScale(.gray500))
                Spacer()
            }
            .padding(.top, 34)
            .padding(.vertical, 10)
        }
    }
    
    var changeStatusButton: some View {
        Button {
            withAnimation {
                isChangeStatusButtonSelected.toggle()
            }
        } label: {
            HStack(spacing: 6) {
                Image(.imgStatusModal)
                Text("상품 상태 변경")
                    .applyNapzakFont(.body4Bold14)
                    .foregroundStyle(Color.napzakGrayScale(.gray500))
                Spacer()
                Image(isChangeStatusButtonSelected ? .iconArrowUpModal : .iconArrowDownModal)
            }
            .padding(.vertical, 10)
        }
    }
    
    var tradeStatusDetailButtons: some View {
        VStack(alignment: .leading, spacing: 16){
            ForEach(tradeStatuses, id: \.self) { status in
                HStack(alignment: .center, spacing: 4) {
                    Button {
                        currentStatus = status
                        withAnimation {
                            isOwnerOptionsModalPresented = false
                        }
                    } label: {
                        Image(currentStatus == status ? .imgRadioSelected : .imgRadioDefault)
                        Text(statusText(status: status))
                            .frame(height: 18)
                            .applyNapzakFont(.body4Bold14)
                            .foregroundStyle(currentStatus == status ? Color.napzakPrimary(.purple500) : Color.napzakGrayScale(.gray500))
                    }
                    Spacer()
                }
                .padding(.leading, 30)
            }
        }
        .padding(.vertical, 16)
    }
    
    var deleteButton: some View {
        Button {
            withAnimation {
                isOwnerOptionsModalPresented = false
            }
            isChangeStatusButtonSelected = false
        } label: {
            HStack(spacing: 6) {
                Image(.imgDeleteModal)
                Text("삭제하기")
                    .applyNapzakFont(.body4Bold14)
                    .foregroundStyle(Color.napzakState(.red))
                Spacer()
            }
            .padding(.vertical, 10)
        }
    }
}

private extension ProductOwnerOptionsModalView {
    
    //MARK: - Private func
    
    func statusText(status: TradeStatus) -> String {
        switch status {
        case .beforeTrade:
            return "\(tradeType.title)중"
        case .reserved:
            return "예약중"
        case .completed:
            return "\(tradeType.title)완료"
        }
    }
}

#Preview {
    struct PreviewContainer: View {
        @State private var isViewerOptionsPresented = true
        @State private var currentStatus: TradeStatus = .beforeTrade
        
        var body: some View {
            ProductOwnerOptionsModalView(
                isOwnerOptionsModalPresented: $isViewerOptionsPresented,
                currentStatus: $currentStatus,
                tradeType: .buy
            )
        }
    }
    
    return PreviewContainer()
}
