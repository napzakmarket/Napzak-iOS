//
//  SellRegisterDelivery.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/9/25.
//

import SwiftUI

struct SellRegisterDelivery: View {
    @ObservedObject var viewModel: RegisterViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("배송 방법")
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .frame(height: 18)
                .padding(.bottom, 24)
            
            deliveryRow(title: "배송비 포함", isSelected: viewModel.model.deliveryType == .included) {
                viewModel.model.deliveryType = .included
            }
            .padding(.bottom, 10)
            
            VStack(spacing: 0) {
                deliveryRow(title: "배송비 별도", isSelected: viewModel.model.deliveryType == .separate) {
                    viewModel.model.deliveryType = .separate
                }
                
                if viewModel.model.deliveryType == .separate {
                    VStack(spacing: 12) {
                        HStack {
                            Image(viewModel.normalDelivery ? .buttonCheckboxFill : .buttonCheckbox)
                                .frame(width: 24, height: 24)
                                .onTapGesture {
                                    viewModel.normalDelivery.toggle()
                                }
                            
                            Text("일반 택배")
                                .applyNapzakFont(.body6Regular14)
                                .foregroundStyle(Color.napzakGrayScale(.gray400))
                                .frame(height: 18)
                            
                            Spacer()
                            
                            HStack(spacing: 0){
                                TextField("100~30,000", text: $viewModel.model.standardDeliveryFee)
                                    .multilineTextAlignment(.trailing)
                                    .onChange(of: viewModel.model.standardDeliveryFee) { newValue in
                                        viewModel.model.standardDeliveryFee = newValue.convertPrice(maxPrice: viewModel.normalMaxDeliveryCharge)
                                    }
                                    .foregroundStyle(Color.napzakGrayScale(.gray400))
                                
                                Text(" 원")
                                    .foregroundStyle(
                                        viewModel.model.standardDeliveryFee.isEmpty ? Color
                                            .napzakGrayScale(.gray100) : Color
                                            .napzakGrayScale(.gray400)
                                    )
                            }
                            .applyNapzakFont(.body5SemiBold14)
                            .frame(height: 18)
                        }
                        
                        HStack {
                            Image(viewModel.halfDelivery ? .buttonCheckboxFill : .buttonCheckbox)
                                .frame(width: 24, height: 24)
                                .onTapGesture {
                                    viewModel.halfDelivery.toggle()
                                }
                            
                            Text("반값/알뜰 택배")
                                .applyNapzakFont(.body6Regular14)
                                .foregroundStyle(Color.napzakGrayScale(.gray400))
                                .frame(height: 18)
                            
                            Spacer()
                            
                            HStack(spacing: 0){
                                TextField("0~5,000", text: $viewModel.model.halfDeliveryFee)
                                    .multilineTextAlignment(.trailing)
                                    .onChange(of: viewModel.model.halfDeliveryFee) { newValue in
                                        viewModel.model.halfDeliveryFee = newValue
                                            .convertPrice(maxPrice: viewModel.halfMaxDeliveryCharge)
                                    }
                                    .foregroundStyle(Color.napzakGrayScale(.gray400))
                                
                                Text(" 원")
                                    .foregroundStyle(
                                        viewModel.model.halfDeliveryFee.isEmpty ? Color
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
        .padding(.bottom, 25)
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
