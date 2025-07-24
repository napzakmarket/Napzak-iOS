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
                            searchWord: tabRouter.currentSearchWord,
                            sortOption: tabRouter.currentSortOption,
                            selectedTab: tabRouter.currentSelectedTab,
                            isGenreSelectModalPresented: $isGenreSelectModalPresented,
                            isSortModalPresented: $isSortModalPresented
                        )
                        .id("\(tabRouter.currentSearchWord)-\(tabRouter.currentSortOption)-\(tabRouter.currentSelectedTab)")
                        .tag(NZTab.search)
                        
                        
                        ChatView()
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
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    if !(isGenreSelectModalPresented || isSortModalPresented) && navigationRouter.path.isEmpty {
                        tabBar
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .animation(.easeInOut(duration: 0.3), value: isRegisterTabSelected)
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
                ZStack(alignment: .bottom) {
                    switch route {
                    case .searchInputView:
                        SearchInputView()
                        
                    case .likeView:
                        LikeView()
                        
                    case .marketView(let storeId):
                        MarketView(storeId: storeId)
                        
                    case .profileEditView:
                        ProfileEditView()

                case .genreDetailView(genreId: let genreId, genreName: let genreName):
                    GenreDetailView(genreId: genreId, genreName: genreName)
                    
                case .productDetailView(productId: let productId):
                    ProductDetailView(viewModel: ProductDetailViewModel(productId: productId))

                case .settingView:
                    SettingView()

                    case .withDrawSelectReasonView:
                        WithDrawSelectReasonView()
                        
                    case .withDrawWriteReasonView:
                        WithDrawWriteReasonView()
                        
                    case .withDrawConfirmView:
                        WithDrawConfirmView()
                        
                    case .searchView(searchWord: let searchWord):
                        SearchView(
                            searchWord: searchWord,
                            sortOption: .recent,
                            selectedTab: 0,
                            isGenreSelectModalPresented: $isGenreSelectModalPresented,
                            isSortModalPresented: $isSortModalPresented
                        )
                        
                    case .reportView(reportType: let reportType, id: let id):
                        ReportView(reportType: reportType, id: id)
                    case .chatView:
                        ChatDetailView(viewModel: ChatDetailViewModel())
                    case .chatDetailView:
                           ChatDetailView(viewModel: ChatDetailViewModel())
                    }
                    
                    if shouldShowTabBarForRoute(route) {
                        VStack(spacing: 10) {
                            if isRegisterTabSelected {
                                RegisterFloatingView(isRegisterViewPresented: $isRegisterViewPresented, registerType: $registerType)
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                            }
                            if !(isGenreSelectModalPresented || isSortModalPresented) {
                                tabBar
                            }
                        }
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
        .onReceive(SearchEventManager.shared.searchCompleted) { searchWord in
            navigationRouter.reset()
            tabRouter.switchToSearch(searchWord: searchWord, sortOption: .recent, searchTabIndex: 0)
        }
    }
    
    private func shouldShowTabBarForRoute(_ route: Route) -> Bool {
        switch route {
        case .likeView:
            return true
        default:
            return false
        }
    }
    
    var tabBar: some View {
        HStack {
            Button {
                navigationRouter.reset()
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
                navigationRouter.reset()
                tabRouter.switchToSearch(searchWord: "", sortOption: .recent, searchTabIndex: 0)
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
                navigationRouter.reset()
                isRegisterTabSelected.toggle()
            } label: {
                VStack(alignment: .center, spacing: 5) {
                    ZStack(alignment: .center){
                        Image(isRegisterTabSelected ? .iconTabRegisterBgSelected : .iconTabRegisterBgDefault)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        Image(.iconTabRegisterPlus)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 13, height: 13)
                            .rotationEffect(.degrees(isRegisterTabSelected ? 45 : 0))
                            .animation(.easeInOut(duration: 0.3), value: isRegisterTabSelected)
                    }
                    Text("등록")
                        .applyNapzakFont(.caption1SemiBold12)
                        .foregroundStyle(isRegisterTabSelected ? Color.napzakPrimary(.purple500) : Color.napzakGrayScale(.gray200))
                }
            }
            Spacer()
            Button {
                navigationRouter.reset()
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
                navigationRouter.reset()
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

#Preview {
    NZTabBarView()
        .environmentObject(NavigationRouter())
}
