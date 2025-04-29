//
//  RegisterFloatingView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/4/25.
//

import SwiftUI

struct RegisterFloatingView: View {
    
    //MARK: - Property Wrappers
    
    @Binding var isRegisterViewPresented: Bool
    @Binding var registerType: RegisterType
    
    @State private var isHighlightedSellArea = false
    @State private var isHighlightedBuyArea = false

    //MARK: - Body
        
    var body: some View {
        VStack(spacing: 0) {
            sellTapArea
            Color.napzakGrayScale(.gray100)
                .frame(height: 1)
            buyTapArea
        }
        .frame(width: 190)
        .cornerRadius(10)
        .background(
            Color.napzakGrayScale(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: .black.opacity(0.25), radius: 4, y: 5)
        )
    }
    
    //MARK: - UI Properties
    
    var sellTapArea: some View {
        HStack(alignment: .center, spacing: 5) {
            Image(.imgRegisterFloatingSell)
                .resizable()
                .scaledToFit()
                .frame(width: 17.56, height: 17.11)
                .padding(.leading, 52)
            Text("팔아요 등록")
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(isHighlightedSellArea ? Color.napzakPrimary(.purple500) : Color.napzakGrayScale(.gray400))
                .padding(.vertical, 14)
                .padding(.trailing, 52)
        }
        .background(isHighlightedSellArea ? Color.napzakGrayScale(.gray50) : Color.napzakGrayScale(.white))
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    isHighlightedSellArea = true
                }
                .onEnded { _ in
                    isHighlightedSellArea = false

                    //TODO: 팔아요 등록 뷰 present
                    Task{
                        registerType = .sell
                    }
                    isRegisterViewPresented = true

                }
        )
    }
    
    var buyTapArea: some View {
        HStack(alignment: .center, spacing: 5) {
            Image(.imgRegisterFloatingBuy)
                .resizable()
                .scaledToFit()
                .frame(width: 18, height: 18)
                .padding(.leading, 52)
            Text("구해요 등록")
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(isHighlightedBuyArea ? Color.napzakPrimary(.purple500) : Color.napzakGrayScale(.gray400))
                .padding(.vertical, 16)
                .padding(.trailing, 52)
        }
        .background(isHighlightedBuyArea ? Color.napzakGrayScale(.gray50) : Color.napzakGrayScale(.white))
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    isHighlightedBuyArea = true
                }
                .onEnded { _ in
                    isHighlightedBuyArea = false

                    //TODO: 구해요 등록 뷰 present
                    Task{
                        registerType = .buy
                    }
                    isRegisterViewPresented = true

                }
        )
    }

}
