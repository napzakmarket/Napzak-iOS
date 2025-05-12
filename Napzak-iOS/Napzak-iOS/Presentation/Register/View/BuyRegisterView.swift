//
//  BuyRegisterView.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/9/25.
//

import SwiftUI

struct BuyRegisterView: View {
    @StateObject private var registerRouter = RegisterNavigationRouter()
    @StateObject var viewModel: RegisterViewModel
    
    @Binding var isRegisterTabSelected: Bool
    
    var body: some View {
        NavigationStack(path: $registerRouter.path) {
            VStack(spacing: 0){
                BuyRegisterHeader()
                
                ScrollView {
                    VStack(spacing: 0) {
                        BuyRegisterContent
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                registerButton
            }
            .ignoresSafeArea()
            .scrollDismissesKeyboard(.immediately)
            .frame(maxWidth: .infinity)
            .scrollIndicators(.hidden)
            .background(Color.napzakGrayScale(.gray10))
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
                }
            }
        }
        .onAppear {
            isRegisterTabSelected = false
        }
    }
}

extension BuyRegisterView {
    private var BuyRegisterContent: some View {
        VStack(spacing: 0) {
            RegisterImage(imagePickerManager: viewModel.imagePickerManager)
                .padding(.top, 30)
                .padding(.leading, 28)
                .padding(.bottom, 27)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
            
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
                .background(.white)

            RegisterTitle(title: $viewModel.model.title)
                .padding(.horizontal, 28)
                .padding(.bottom, 10)
                .background(.white)

            RegisterDescription(description: $viewModel.model.description)
                .padding(.horizontal, 28)
                .padding(.bottom, 23)
                .background(.white)

            Rectangle()
                .fill(Color.napzakGrayScale(.gray10))
                .frame(height: 4)
                .padding(.bottom, 23)
                .background(.white)

            BuyRegisterPrice(
                price: $viewModel.model.price,
                addPrices: $viewModel.addPrices,
                maxPrice: $viewModel.maxPrice,
                priceError: $viewModel.priceError
            )
                .padding(.horizontal, 28)
                .padding(.bottom, 32)
                .background(.white)

            BuyRegisterSuggestPrice(isPriceNegotiable: $viewModel.model.isPriceNegotiable)
                .padding(.horizontal, 28)
        }
    }
    
    private var registerButton: some View {
        ZStack() {
            Color.napzakGrayScale(.white)
                .frame(height: 108)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 1)
            
            Button {
                Task {
                    await viewModel.buyRegister()
                }
            } label: {
                Text("등록하기")
                    .applyNapzakFont(.body4Bold14)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
            }
            .background(
                viewModel.sharedValidate ? Color.napzakPrimary(.purple500) :
                    Color.napzakGrayScale(.gray100)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding(.horizontal, 28)
            .padding(.top, 18)
            .padding(.bottom, 40)
            .disabled(!viewModel.sharedValidate)

        }
    }
    
}
