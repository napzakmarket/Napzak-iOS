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
    @EnvironmentObject private var phoneVerificationManager: PhoneVerificationManager
    
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
                switch tabRouter.selectedTab {
                case .home:
                    HomeView(isTabBarHidden: $isTabBarHidden)
                case .search:
                    SearchView(
                        searchWord: tabRouter.currentSearchWord,
                        sortOption: tabRouter.currentSortOption,
                        selectedTab: tabRouter.currentSelectedTab,
                        isGenreSelectModalPresented: $isGenreSelectModalPresented,
                        isSortModalPresented: $isSortModalPresented,
                        isTabBarHidden: $isTabBarHidden
                    )
                case .chat:
                    ChatView(isTabBarHidden: $isTabBarHidden)
                case .my:
                    MyPageView(isTabBarHidden: $isTabBarHidden)
                }
                
                if isRegisterTabSelected {
                    Color.clear
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture { isRegisterTabSelected = false }
                }
                
                
            }
            .overlay(
                Group {
                    if !(isGenreSelectModalPresented || isSortModalPresented), !isTabBarHidden {
                        VStack(spacing: 10) {
                            if isRegisterTabSelected {
                                RegisterFloatingView(
                                    isRegisterViewPresented: $isRegisterViewPresented,
                                    registerType: $registerType
                                )
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                            }
                            tabBar
                        }
                    }
                },
                alignment: .bottom
            )
            .overlay(
                Group {
                    if showPermissionModal, let state = currentPushOffState {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                        
                        PermissionAlertView(
                            content: .push(state),
                            onDismiss: {
                                showPermissionModal = false
                            },
                            onPrimaryAction: {
                                switch state {
                                case .appOnlyOff:
                                    showPermissionModal = false
                                    tabRouter.switchToMy()
                                    navigationRouter.push(next: .settingView)

                                case .osOnlyOff, .bothOff:
                                    showPermissionModal = false
                                    if let url = URL(string: UIApplication.openSettingsURLString) {
                                        UIApplication.shared.open(url)
                                    }
                                }
                            }
                        )
                        .frame(width: 284, height: 290)
                        .transition(.opacity)
                        .centerInParent()
                    } else if shouldPresentRootPhoneVerificationModal {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()

                        PermissionAlertView(
                            content: .phoneVerification,
                            onDismiss: {
                                phoneVerificationManager.dismissModal()
                            },
                            onPrimaryAction: {
                                phoneVerificationManager.dismissModal()
                                navigationRouter.push(next: .phoneVerificationView)
                            }
                        )
                        .frame(width: 284, height: 290)
                        .transition(.opacity)
                        .centerInParent()
                    }
                }
            )
            .animation(.easeInOut(duration: 0.3), value: isRegisterTabSelected)
            .animation(.easeInOut(duration: 0.3), value: showPermissionModal)
            .animation(.easeInOut(duration: 0.3), value: phoneVerificationManager.isModalPresented)
            .fullScreenCover(isPresented: $isRegisterViewPresented) {
                switch registerType {
                case .sell:
                    SellRegisterView(viewModel: RegisterViewModel(viewType: .initialRegister),
                                     isRegisterTabSelected: $isRegisterTabSelected,
                                     isEditCompleted: .constant(false))
                case .buy:
                    BuyRegisterView(viewModel: RegisterViewModel(viewType: .initialRegister),
                                    isRegisterTabSelected: $isRegisterTabSelected,
                                    isEditCompleted: .constant(false))
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .phoneVerificationView:
                    PhoneVerificationView(
                        navigationStyle: .basic,
                        shouldRegisterOnNext: true,
                        onBack: {
                            if let entryPoint = phoneVerificationManager.currentEntryPoint {
                                phoneVerificationManager.presentModal(for: entryPoint)
                            }
                            navigationRouter.pop()
                        },
                        onNext: {
                            handlePhoneVerificationCompletion()
                        }
                    )

                case .searchInputView:
                    SearchInputView()
                    
                case .likeView:
                    VStack {
                        LikeView()
                        if shouldShowTabBarForRoute(route) {
                            if isRegisterTabSelected {
                                RegisterFloatingView(
                                    isRegisterViewPresented: $isRegisterViewPresented,
                                    registerType: $registerType
                                )
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                            }

                            if !(isGenreSelectModalPresented || isSortModalPresented) {
                                tabBar
                            }
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: isRegisterTabSelected)
                    
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
                    
                case .chatDetailView(let chatEntry):
                    ChatDetailView(viewModel: ChatDetailViewModel(chatEntry: chatEntry))
                }
            }
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

            if newTab == .home {
                Task {
                    await presentHomePhoneVerificationModalIfNeeded()
                }
            }
        }
        .onAppear {
            Task {
                await presentHomePhoneVerificationModalIfNeeded()
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
    
    private func presentHomePhoneVerificationModalIfNeeded() async {
        guard tabRouter.selectedTab == .home else {
            return
        }

        let status = await phoneVerificationManager.resolveVerificationStatusIfNeeded()
        guard status == .unverified,
              phoneVerificationManager.canPresentHomeModal() else {
            return
        }

        phoneVerificationManager.presentModal(for: .homeModal)
    }

    private var shouldPresentRootPhoneVerificationModal: Bool {
        guard phoneVerificationManager.isModalPresented,
              let entryPoint = phoneVerificationManager.currentEntryPoint else {
            return false
        }

        switch entryPoint {
        case .homeModal, .registerSell, .registerBuy:
            return true
        case .chatPush, .productDetailChat, .chatRoom:
            return false
        }
    }

    private func handlePhoneVerificationCompletion() {
        let entryPoint = phoneVerificationManager.currentEntryPoint

        phoneVerificationManager.dismissModal()
        phoneVerificationManager.setEntryPoint(nil)
        navigationRouter.pop()

        switch entryPoint {
        case .registerSell:
            registerType = .sell
            isRegisterTabSelected = false
            isRegisterViewPresented = true

        case .registerBuy:
            registerType = .buy
            isRegisterTabSelected = false
            isRegisterViewPresented = true

        case .homeModal, .productDetailChat, .chatPush, .chatRoom, .none:
            break
        }
    }

    var tabBar: some View {
        HStack {
            Button {
                navigationRouter.reset()
                tabRouter.switchToHome()
                isRegisterTabSelected = false
            } label: {
                VStack(spacing: 5) {
                    Image(isSelectedTab(.home) ? .iconTabHomeSelected : .iconTabHomeDefault)
                        .resizable().scaledToFit().frame(width: 25, height: 25)
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
                VStack(spacing: 5) {
                    Image(isSelectedTab(.search) ? .iconTabSearchSelected : .iconTabSearchDefault)
                        .resizable().scaledToFit().frame(width: 25, height: 25)
                    Text("탐색")
                        .applyNapzakFont(.caption1SemiBold12)
                        .foregroundStyle(isSelectedTab(.search) ? Color.napzakPrimary(.purple500) : Color.napzakGrayScale(.gray200))
                }
            }
            Spacer()
            Button {
//                navigationRouter.reset()
                isRegisterTabSelected.toggle()
            } label: {
                VStack(spacing: 5) {
                    ZStack {
                        Image(isRegisterTabSelected ? .iconTabRegisterBgSelected : .iconTabRegisterBgDefault)
                            .resizable().scaledToFit().frame(width: 25, height: 25)
                        Image(.iconTabRegisterPlus)
                            .resizable().scaledToFit().frame(width: 13, height: 13)
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
                VStack(spacing: 5) {
                    Image(isSelectedTab(.chat) ? .iconTabChatSelected : .iconTabChatDefault)
                        .resizable().scaledToFit().frame(width: 25, height: 25)
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
                VStack(spacing: 5) {
                    Image(isSelectedTab(.my) ? .iconTabMySelected : .iconTabMyDefault)
                        .resizable().scaledToFit().frame(width: 25, height: 25)
                    Text("마이")
                        .applyNapzakFont(.caption1SemiBold12)
                        .foregroundStyle(isSelectedTab(.my) ? Color.napzakPrimary(.purple500) : Color.napzakGrayScale(.gray200))
                }
            }
        }
        .padding(.horizontal, 40)
        .padding(.top, 15)
        .padding(.bottom, 0)
        .background(
            Color.napzakGrayScale(.white)
                .shadow(color: .black.opacity(0.4), radius: 0.4)
                .ignoresSafeArea(.container, edges: .bottom)
        )
    }
}

private extension NZTabBarView {
    
    //MARK: - Private Method
    
    private func isSelectedTab(_ tab: NZTab) -> Bool {
        tabRouter.selectedTab == tab && !isRegisterTabSelected
    }
    
    private func shouldShowTabBarForRoute(_ route: Route) -> Bool {
        route == .likeView
    }
}

#Preview {
    NZTabBarView()
        .environmentObject(NavigationRouter())
        .environmentObject(TabRouter())
        .environmentObject(PushPermissionManager())
}
