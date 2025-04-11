//
//  SellRegisterDelivery.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/9/25.
//

import SwiftUI

struct SellRegisterDelivery: View {
    enum DeliveryType {
        case included, separate
    }
    
    @State private var deliveryType: DeliveryType? = nil  // 배달 타입
    @State var normalDelivery: Bool = false                     // 일반 배달비 선택 여부
    @State var normalDeliveryCharge: String = ""                // 일반 배달비 금액
    @State var halfDelivery: Bool = false                       // 알뜰,반값 배달비 선택 여부
    @State var halfDeliveryCharge: String = ""                  // 알뜰,반값 배달비 금액
    
    private let normalMaxDeliveryCharge: Int = 30_000           // 최대 금액 3만원
    private let halfMaxDeliveryCharge: Int = 5_000              // 최대 금액 5000원
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("배송 방법")
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .frame(height: 18)
                .padding(.bottom, 24)
            
            deliveryRow(title: "배송비 포함", isSelected: deliveryType == .included) {
                deliveryType = .included
            }
            .padding(.bottom, 10)
            
            VStack(spacing: 0) {
                deliveryRow(title: "배송비 별도", isSelected: deliveryType == .separate) {
                    deliveryType = .separate
                }
                
                if deliveryType == .separate {
                    VStack(spacing: 12) {
                        HStack {
                            Image(normalDelivery ? .buttonCheckboxFill : .buttonCheckbox)
                                .frame(width: 24, height: 24)
                                .onTapGesture {
                                    normalDelivery.toggle()
                                }
                            
                            Text("일반 택배")
                                .applyNapzakFont(.body6Regular14)
                                .foregroundStyle(Color.napzakGrayScale(.gray400))
                                .frame(height: 18)
                            
                            Spacer()
                            
                            HStack(spacing: 0){
                                TextField("100~30,000", text: $normalDeliveryCharge)
                                    .multilineTextAlignment(.trailing)
                                    .onChange(of: normalDeliveryCharge) { newValue in
                                        normalDeliveryCharge = newValue.convertPrice(maxPrice: normalMaxDeliveryCharge)
                                    }
                                    .foregroundStyle(Color.napzakGrayScale(.gray400))
                                
                                Text(" 원")
                                    .foregroundStyle(
                                        normalDeliveryCharge.isEmpty ? Color
                                            .napzakGrayScale(.gray100) : Color
                                            .napzakGrayScale(.gray400)
                                    )
                            }
                            .applyNapzakFont(.body5SemiBold14)
                            .frame(height: 18)
                        }
                        
                        HStack {
                            Image(halfDelivery ? .buttonCheckboxFill : .buttonCheckbox)
                                .frame(width: 24, height: 24)
                                .onTapGesture {
                                    halfDelivery.toggle()
                                }
                            
                            Text("반값/알뜰 택배")
                                .applyNapzakFont(.body6Regular14)
                                .foregroundStyle(Color.napzakGrayScale(.gray400))
                                .frame(height: 18)
                            
                            Spacer()
                            
                            HStack(spacing: 0){
                                TextField("0~5,000", text: $halfDeliveryCharge)
                                    .multilineTextAlignment(.trailing)
                                    .onChange(of: halfDeliveryCharge) { newValue in
                                        halfDeliveryCharge = newValue
                                            .convertPrice(maxPrice: halfMaxDeliveryCharge)
                                    }
                                    .foregroundStyle(Color.napzakGrayScale(.gray400))
                                
                                Text(" 원")
                                    .foregroundStyle(
                                        halfDeliveryCharge.isEmpty ? Color
                                            .napzakGrayScale(.gray100) : Color
                                            .napzakGrayScale(.gray400)
                                    )
                            }
                            .applyNapzakFont(.body5SemiBold14)
                            .frame(height: 18)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 22)
                    .padding(.top, 18)

                }
            }
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.napzakGrayScale(.gray50))
            )
        }
        .padding(.bottom, deliveryType == .separate ? 95 : 34)

        
    }
    
}

extension SellRegisterDelivery {
    private func deliveryRow(title: String, isSelected: Bool, onTap: @escaping () -> Void) -> some View {
        HStack(spacing: 8) {
            Image(isSelected ? .checkboxSelected: .checkboxDefault)
                .onTapGesture(perform: onTap)
            
            Text(title)
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(Color.napzakGrayScale(.gray400))
                .frame(height: 18)
            
            Spacer()
        }
        .padding(.vertical, 13.5)
        .padding(.horizontal, 10)
        .background(Color.napzakGrayScale(.gray50))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
