//
//  SellRegisterView.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/8/25.
//

import SwiftUI

struct SellRegisterView: View {
    @EnvironmentObject var navigationRouter: NavigationRouter
    @StateObject private var registerRouter = RegisterNavigationRouter()
    @StateObject var viewModel: RegisterViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isKeyboardActive: Bool
    
    @Binding var isRegisterTabSelected: Bool
    
    var body: some View {
        NavigationStack(path: $registerRouter.path) {
            VStack(spacing: 0){
                SellRegisterHeader()
                
                ScrollView {
                    VStack(spacing: 0) {
                        SellRegisterContent
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                registerButton
            }
            .ignoresSafeArea()
            .scrollDismissesKeyboard(.immediately)
            .frame(maxWidth: .infinity)
            .scrollIndicators(.hidden)
            .navigationDestination(for: RegisterRoute.self) { route in
                switch route {
                case .registerSearchGenre:
                    RegisterSearchGenre(
                        registerRouter: registerRouter,
                        genreSearchText: $viewModel.genreSearchText,
                        isCompleted: $viewModel.isCompleted,
                        genreList: $viewModel.genreList,
                        genre: $viewModel.model.genre,
                        genreId: $viewModel.model.genreId
                    )
                    .onChange(of: viewModel.genreSearchText) { word in
                        Task {
                            if word.isEmpty {
                                await viewModel.getAllGenre()
                            } else {
                                await viewModel.getSearchGenre(searchWord: word)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            isRegisterTabSelected = false
        }
    }
}

extension SellRegisterView {
    private var SellRegisterContent: some View {
        VStack(spacing: 0) {
            RegisterImage(imagePickerManager: viewModel.imagePickerManager)
                .padding(.top, 30)
                .padding(.leading, 28)
                .padding(.bottom, 27)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            RegisterGenre(genre: $viewModel.model.genre)
                .padding(.horizontal, 18)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 21)
                .background(.white)
                .onTapGesture {
                    registerRouter.push(next: .registerSearchGenre)
                }
            
            Rectangle()
                .fill(Color.napzakGrayScale(.gray10))
                .frame(height: 4)
                .padding(.bottom, 29)
            
            RegisterTitle(title: $viewModel.model.title)
                .padding(.horizontal, 28)
                .padding(.bottom, 10)
                .focused($isKeyboardActive)
            
            RegisterDescription(description: $viewModel.model.description)
                .padding(.horizontal, 28)
                .padding(.bottom, 23)
                .focused($isKeyboardActive)
            
            Rectangle()
                .fill(Color.napzakGrayScale(.gray10))
                .frame(height: 4)
                .padding(.bottom, 23)
            
            SellRegisterProductState(productCondition: $viewModel.model.productCondition)
                .padding(.horizontal, 28)
                .padding(.bottom, 30)
            
            SellRegisterPrice(
                price: $viewModel.model.price,
                addPrices: $viewModel.addPrices,
                maxPrice: $viewModel.maxPrice
            )
            .padding(.horizontal, 28)
            .padding(.bottom, 30)
            .focused($isKeyboardActive)
            
            SellRegisterDelivery(
                isDeliveryIncluded: $viewModel.model.isDeliveryIncluded,
                standardDeliveryFee: $viewModel.model.standardDeliveryFee,
                halfDeliveryFee: $viewModel.model.halfDeliveryFee,
                normalDelivery: $viewModel.normalDelivery,
                halfDelivery: $viewModel.halfDelivery
            )
            .padding(.horizontal, 28)
        }
        .onTapGesture {
            isKeyboardActive = false
        }
    }
    
    private var registerButton: some View {
        ZStack() {
            Color.napzakGrayScale(.white)
                .frame(height: 108)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 1)
            
            Button {
                //MARK: - 팔아요 등록
                Task {
                    await viewModel.sellRegister()
                    if let productId = viewModel.productId {
                        dismiss()
                        navigationRouter.push(next: .productDetailView(productId: productId))
                    }
                }
            } label: {
                Text("등록하기")
                    .applyNapzakFont(.body4Bold14)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
            }
            .background(
                viewModel.sharedValidate && viewModel.sellRegisterValidate ? Color
                    .napzakPrimary(.purple500) : Color
                    .napzakGrayScale(.gray100)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding(.horizontal, 28)
            .padding(.top, 18)
            .padding(.bottom, 40)
            .disabled(!(viewModel.sharedValidate && viewModel.sellRegisterValidate))
        }
    }
}
