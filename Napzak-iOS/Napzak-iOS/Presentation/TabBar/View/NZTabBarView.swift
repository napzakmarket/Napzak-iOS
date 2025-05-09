//
//  NZTabBarView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/2/25.
//

import SwiftUI

struct NZTabBarView: View {
    
    //MARK: - Enum
    
    enum NZTab {
        case home
        case search
        case chat
        case my
    }
    
    //MARK: - Property Wrappers
    
    @EnvironmentObject private var navigationRouter: NavigationRouter
    
    @State private var selectedTab: NZTab = .home
    @State private var isRegisterTabSelected = false
    @State private var isRegisterViewPresented = false
    @State private var registerType: TradeType = .sell
    @State private var isGenreSelectModalPresented = false
    @State private var isSortModalPresented = false
        
    //MARK: - Body
        
    var body: some View {
        NavigationStack(path: $navigationRouter.path) {
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    Group {
                        HomeView()
                            .tag(NZTab.home)
                        
                        SearchView(
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
                    SellRegisterView(isRegisterTabSelected: $isRegisterTabSelected)
                case .buy:
                    BuyRegisterView(isRegisterTabSelected: $isRegisterTabSelected)
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .sView:
                    SView()
                case .mView:
                    MView()
                case .searchInputView:
                    SearchInputView()
                    
                case .MarketView:
                       MarketView()
                    
                case .ProfileEditView:
                    ProfileEditView()

                case .productDetailView(productId: let productId):
                    ProductDetailView(viewModel: ProductDetailViewModel(productId: productId))

                case .registerSearchGenre:
                    EmptyView()
                }
            }
        }
    }
    
    var tabBar: some View {
        HStack {
            Button {
                selectedTab = .home
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
                selectedTab = .search
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
                selectedTab = .chat
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
                selectedTab = .my
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
        return selectedTab == tab && !isRegisterTabSelected
    }
}

// 아래로 전부! 임시로 띄울 뷰, 삭제 예정
// 로직만 확인해주세요
struct HView: View {
    @EnvironmentObject private var navigationRouter: NavigationRouter
    
    var body: some View {
        VStack {
            Button {
                navigationRouter.push(next: .sView)
            } label: {
                Text("눌러")
                    .background(.red)
            }
            Text("홈")
                .applyNapzakFont(.title1Bold22)
        }
    }
}

struct SView: View {
    @EnvironmentObject private var navigationRouter: NavigationRouter

    var body: some View {
        VStack {
            Button {
                navigationRouter.push(next: .mView)
            } label: {
                Text("다음")
                    .background(.red)
            }
            Text("탐색")
                .applyNapzakFont(.title1Bold22)
        }
    }
}

struct RView: View {
    @Binding var isRegisterTabSelected: Bool
    @Binding var isRegisterViewPresented: Bool
    
    var body: some View {
        VStack {
            Button {
                print("버튼 눌림")
                isRegisterViewPresented = false
            } label: {
                Text("닫기")
                    .background(.red)
            }
            Text("등록")
                .applyNapzakFont(.title1Bold22)
        }
        .onAppear {
            isRegisterTabSelected = false
        }
    }
}

struct CView: View {
    @EnvironmentObject private var navigationRouter: NavigationRouter
    
    var body: some View {
        VStack {
            Button {
                navigationRouter.push(next: .sView)
            } label: {
                Text("눌러")
                    .background(.red)
            }
            Text("채팅")
                .applyNapzakFont(.title1Bold22)
        }
    }
}

struct MView: View {
    @EnvironmentObject private var navigationRouter: NavigationRouter

    var body: some View {
        VStack {
            Button {
                navigationRouter.pop()
            } label: {
                Text("뒤로가기")
                    .background(.red)
            }
            Button {
                navigationRouter.reset()
            } label: {
                Text("맨처음")
                    .background(.red)
            }
            Text("마이")
                .applyNapzakFont(.title1Bold22)
        }
    }
}

#Preview {
    NZTabBarView()
        .environmentObject(NavigationRouter())
}
