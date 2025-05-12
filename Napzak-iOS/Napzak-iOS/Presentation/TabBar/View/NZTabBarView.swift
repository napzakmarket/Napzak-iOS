//
//  NZTabBarView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/2/25.
//

import SwiftUI

struct NZTabBarView: View {
    //MARK: - Property Wrappers
    
    @EnvironmentObject private var navigationRouter: NavigationRouter
    @EnvironmentObject private var tabRouter: TabRouter
    
    @State private var isRegisterTabSelected = false
    @State private var isRegisterViewPresented = false
    @State private var registerType: TradeType = .sell
    @State private var isGenreSelectModalPresented = false
    @State private var isSortModalPresented = false
        
    //MARK: - Body
        
    var body: some View {
        NavigationStack(path: $navigationRouter.path) {
            ZStack(alignment: .bottom) {
                TabView(selection: $tabRouter.selectedTab) {
                    Group {
                        HomeView()
                            .tag(NZTab.home)
                        
                        SearchView(
                            viewModel: SearchViewModel(searchWord: ""),
                            isGenreSelectModalPresented: $isGenreSelectModalPresented,
                            isSortModalPresented: $isSortModalPresented
                        )
                        .tag(NZTab.search)
                        
                        CView()
                            .tag(NZTab.chat)
                        
                        MyPageView()
                            .tag(NZTab.my)
                    }
                    .toolbar(.hidden, for: .tabBar)
                }
                
                if isRegisterTabSelected {
                    Color.clear
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            isRegisterTabSelected = false
                        }
                }
                
                VStack(spacing: 10) {
                    if  isRegisterTabSelected {
                        RegisterFloatingView(isRegisterViewPresented: $isRegisterViewPresented, registerType: $registerType)
                    }
                    if !(isGenreSelectModalPresented || isSortModalPresented){
                        tabBar
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .fullScreenCover(isPresented: $isRegisterViewPresented) {
                switch registerType {
                case .sell:
                    SellRegisterView(viewModel: RegisterViewModel(viewType: .initialRegister),
                                     isRegisterTabSelected: $isRegisterTabSelected)
                case .buy:
                    BuyRegisterView(viewModel: RegisterViewModel(viewType: .initialRegister),
                                    isRegisterTabSelected: $isRegisterTabSelected)
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .searchInputView:
                    SearchInputView()
                    
                case .MarketView:
                       MarketView()
                    
                case .ProfileEditView:
                    ProfileEditView()

                case .genreDetailView(genreId: let genreId, genreName: let genreName):
                    GenreDetailView(
                        viewModel: GenreDetailViewModel(
                            genreId: genreId,
                            genreName: genreName
                        )
                    )
                case .productDetailView(productId: let productId):
                    ProductDetailView(viewModel: ProductDetailViewModel(productId: productId))

                case .SettingView:
                    SettingView()

                case .withDrawSelectReasonView:
                    WithDrawSelectReasonView()
                    
                case .withDrawWriteReasonView:
                    WithDrawWriteReasonView()
                    
                case .withDrawConfirmView:
                    WithDrawConfirmView()
                    
                case .searchView(searchWord: let searchWord):
                    SearchView(
                        viewModel: SearchViewModel(searchWord: searchWord),
                        isGenreSelectModalPresented: $isGenreSelectModalPresented,
                        isSortModalPresented: $isSortModalPresented
                    )
                    
                case .reportView(reportType: let reportType, id: let id):
                    ReportView(reportType: reportType, id: id)
                }
            }
        }
    }
    
    var tabBar: some View {
        HStack {
            Button {
                tabRouter.switchToHome()
                isRegisterTabSelected = false
            } label: {
                VStack(alignment: .center, spacing: 5) {
                    Image(isSelectedTab(.home) ? .iconTabHomeSelected : .iconTabHomeDefault)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    Text("홈")
                        .applyNapzakFont(.caption1SemiBold12)
                        .foregroundStyle(isSelectedTab(.home) ? Color.napzakPrimary(.purple500) : Color.napzakGrayScale(.gray200))
                }
            }
            Spacer()
            Button {
                tabRouter.switchToSearch()
                isRegisterTabSelected = false
            } label: {
                VStack(alignment: .center, spacing: 5) {
                    Image(isSelectedTab(.search) ? .iconTabSearchSelected : .iconTabSearchDefault)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    Text("탐색")
                        .applyNapzakFont(.caption1SemiBold12)
                        .foregroundStyle(isSelectedTab(.search) ? Color.napzakPrimary(.purple500) : Color.napzakGrayScale(.gray200))
                }
            }
            Spacer()
            Button {
                isRegisterTabSelected.toggle()
            } label: {
                VStack(alignment: .center, spacing: 5) {
                    Image(isRegisterTabSelected ? .iconTabRegisterSelected : .iconTabRegisterDefault)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    Text("등록")
                        .applyNapzakFont(.caption1SemiBold12)
                        .foregroundStyle(isRegisterTabSelected ? Color.napzakPrimary(.purple500) : Color.napzakGrayScale(.gray200))
                }
            }
            Spacer()
            Button {
                tabRouter.switchToChat()
                isRegisterTabSelected = false
            } label: {
                VStack(alignment: .center, spacing: 5) {
                    Image(isSelectedTab(.chat) ? .iconTabChatSelected : .iconTabChatDefault)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    Text("채팅")
                        .applyNapzakFont(.caption1SemiBold12)
                        .foregroundStyle(isSelectedTab(.chat) ? Color.napzakPrimary(.purple500) : Color.napzakGrayScale(.gray200))
                }
            }
            Spacer()
            Button {
                tabRouter.switchToMy()
                isRegisterTabSelected = false
            } label: {
                VStack(alignment: .center, spacing: 5) {
                    Image(isSelectedTab(.my) ? .iconTabMySelected : .iconTabMyDefault)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    Text("마이")
                        .applyNapzakFont(.caption1SemiBold12)
                        .foregroundStyle(isSelectedTab(.my) ? Color.napzakPrimary(.purple500) : Color.napzakGrayScale(.gray200))
                }
            }
        }
        .padding(.horizontal, 40)
        .padding(.top, 15)
        .padding(.bottom, 28)
        .frame(height: 88)
        .background(
            Color.napzakGrayScale(.white)
                .shadow(color: .black.opacity(0.4), radius: 0.4)
        )
    }
}

private extension NZTabBarView {
    
    //MARK: - Private Method
    
    func isSelectedTab(_ tab: NZTab) -> Bool {
        return tabRouter.selectedTab == tab && !isRegisterTabSelected
    }
}

struct CView: View {
    @EnvironmentObject private var navigationRouter: NavigationRouter
    
    var body: some View {
        VStack {
            Text("채팅")
                .applyNapzakFont(.title1Bold22)
        }
    }
}

#Preview {
    NZTabBarView()
        .environmentObject(NavigationRouter())
}
