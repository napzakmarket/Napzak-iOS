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
    @EnvironmentObject private var permissionManager: PushPermissionManager
    
    @State private var isRegisterTabSelected = false
    @State private var isRegisterViewPresented = false
    @State private var registerType: TradeType = .sell
    @State private var isGenreSelectModalPresented = false
    @State private var isSortModalPresented = false
    @State private var showPermissionModal: Bool = false
    @State private var currentPushOffState: PushOffState? = nil
    @AppStorage("pushModalShownKey") private var pushModalShown: Bool = false
    @State private var isTabBarHidden: Bool = true
        
    //MARK: - Body
        
    var body: some View {
        NavigationStack(path: $navigationRouter.path) {
            ZStack(alignment: .bottom) {
                TabView(selection: $tabRouter.selectedTab) {
                    Group {
                        HomeView(isTabBarHidden: $isTabBarHidden)
                            .tag(NZTab.home)
                        
                        SearchView(
                            searchWord: tabRouter.currentSearchWord,
                            sortOption: tabRouter.currentSortOption,
                            selectedTab: tabRouter.currentSelectedTab,
                            isGenreSelectModalPresented: $isGenreSelectModalPresented,
                            isSortModalPresented: $isSortModalPresented,
                            isTabBarHidden: $isTabBarHidden
                        )
                        .id("\(tabRouter.currentSearchWord)-\(tabRouter.currentSortOption)-\(tabRouter.currentSelectedTab)")
                        .tag(NZTab.search)
                        
                        
                        ChatView()
                            .tag(NZTab.chat)
                        
                        MyPageView(isTabBarHidden: $isTabBarHidden)
                            .tag(NZTab.my)
                    }
                    .toolbar(.hidden, for: .tabBar)
                }
                .onChange(of: tabRouter.selectedTab) { newTab in
                    if permissionManager.pushOffState == nil {
                        pushModalShown = false
                    }
                    
                    if newTab == .chat,
                       let state = permissionManager.pushOffState,
                       !pushModalShown {
                        
                        currentPushOffState = state
                        showPermissionModal = true
                        pushModalShown = true
                    }
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
                    if !(isGenreSelectModalPresented || isSortModalPresented){
                        if !isTabBarHidden {
                            tabBar
                        }
                    }
                }
                
                if showPermissionModal, let state = currentPushOffState {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                    
                    PermissionModalView(state: state) {
                        showPermissionModal = false
                    }
                    .frame(width: 284, height: 290)
                    .transition(.opacity)
                    .centerInParent()
                }
            }
            .edgesIgnoringSafeArea([.top, .bottom])
            .animation(.easeInOut(duration: 0.3), value: isRegisterTabSelected)
            .animation(.easeInOut(duration: 0.3), value: showPermissionModal)
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
                        isSortModalPresented: $isSortModalPresented,
                        isTabBarHidden: $isTabBarHidden
                    )
                    
                case .reportView(reportType: let reportType, id: let id):
                    ReportView(reportType: reportType, id: id)
                case .chatDetailView:
                    ChatDetailView(viewModel: ChatDetailViewModel())
                }
            }
        }
        .onReceive(SearchEventManager.shared.searchCompleted) { searchWord in
            navigationRouter.reset()
            tabRouter.switchToSearch(searchWord: searchWord, sortOption: .recent, searchTabIndex: 0)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            Task {
                await permissionManager.refreshOSPushStatus()
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

#Preview {
    NZTabBarView()
        .environmentObject(NavigationRouter())
        .environmentObject(TabRouter())
        .environmentObject(PushPermissionManager())
}
