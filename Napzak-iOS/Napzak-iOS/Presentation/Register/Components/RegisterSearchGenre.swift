//
//  RegisterSearchGenre.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/29/25.
//

import SwiftUI

struct RegisterSearchGenre: View {
    @ObservedObject var registerRouter: RegisterNavigationRouter
    
    @Environment(\.openURL) var openURL
    
    @Binding var genreSearchText: String
    @Binding var isCompleted: Bool
    @Binding var genreList: [GenreNameModel]
    @Binding var genre: String
    @Binding var genreId: Int?
    
    @StateObject private var keyboard = KeyboardObserver()
    
    var body: some View {
        ZStack(alignment: .top) {
            genreListScrollView
            headerView
            
            if keyboard.keyboardHeight > 0 {
                LinearGradient(
                    gradient: Gradient(colors: [
                        .white.opacity(0),
                        .white
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .padding(.top, UIScreen.main.bounds.height/2)
                .allowsHitTesting(false)
            }
        }
        .ignoresSafeArea()
        .background(Color.napzakGrayScale(.gray10))
        .navigationBarBackButtonHidden()
        .onTapGesture {
            self.dismissKeyboard()
        }
    }
}

extension RegisterSearchGenre {
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 0){
            Button {
                registerRouter.pop()
            } label: {
                Image(.iconBack)
            }
            .frame(width: 24, height: 24)
            .padding(.top, 58)
            .padding(.leading, 21)
            .padding(.bottom, 38)
            
            Text("등록하실 상품의\n장르를 선택해주세요")
                .lineLimit(2)
                .applyNapzakFont(.title2Bold20)
                .fixedSize(horizontal: false, vertical: true)
                .frame(height: 52)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .padding(.leading, 28)
                .padding(.bottom, 25)
            
            SearchBar(placeholder: "어떤 장르의 굿즈인가요? 검색해보세요!",
                      cornerRadius: 14,
                      text: $genreSearchText,
                      isCompleted: $isCompleted,
                      onSubmit: { })
            .padding(.horizontal, 27)
            .padding(.bottom, 24)
            
        }
        .background(
            Color.napzakGrayScale(.white)
                .shadow(color: .black.opacity(0.1), radius: 4)
        )
    }
    
    private var genreListScrollView: some View {
        ScrollView(showsIndicators: false) {
            if !genreList.isEmpty {
                LazyVStack(alignment: .leading) {
                    ForEach(genreList, id: \.self){ selectedGenre in
                        Button {
                            genre = selectedGenre.name
                            genreId = selectedGenre.id
                            registerRouter.pop()
                        } label: {
                            HStack(spacing: 0) {
                                Text("\(selectedGenre.name)")
                                    .applyNapzakFont(
                                        genre == selectedGenre.name ? .body5SemiBold14 : .body6Regular14
                                    )
                                    .foregroundStyle(
                                        genre == selectedGenre.name ? Color
                                            .napzakPrimary(.purple500) : Color
                                            .napzakGrayScale(.gray400)
                                    )
                                    .padding(10)
                                
                                Spacer()
                                    .background(.clear)
                            }
                        }
                    }
                }
                .padding(.top, 15)
                .padding(.bottom, 128)
                .padding(.leading, 18)
            } else {
                VStack(alignment: .center, spacing: 0){
                    Image(.iconEmptySearchGenreIos)
                        .padding(.top, 60)
                        .padding(.bottom, 20)
                    
                    Text("죄송해요, 찾으시는 장르가 아직 없네요\n원하시는 장르를 알려주시면 빠르게 추가할게요!")
                        .applyNapzakFont(.body6Regular14)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundStyle(Color.napzakGrayScale(.gray300))
                        .frame(height: 36)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 57)
                    
                    Button {
                        guard let url = URL(string: Bundle.main.infoDictionary?["GENRE_REQUEST_URL"] as! String) else {return}
                        openURL(url)
                        print("장르 추가 요청 버튼 클릭")
                    } label: {
                        Text("장르 추가 요청하기")
                            .applyNapzakFont(.body5SemiBold14)
                            .foregroundStyle(Color.napzakPrimary(.purple500))
                            .padding(.vertical, 9)
                            .padding(.horizontal, 11)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 9)
                            .stroke(Color.napzakPrimary(.purple500), lineWidth: 1)
                    }
                    .padding(.top, 19)
                }
            }
        }
        .padding(.top, 260)
    }
    
}

#Preview {
    @StateObject var registerRouter = RegisterNavigationRouter()
    @State var genreSearchText: String = ""
    @State var isCompleted: Bool = false
    @State var genreList: [GenreNameModel] = []
    @State var genre: String = ""
    @State var genreId: Int?

    
    RegisterSearchGenre(registerRouter: registerRouter, genreSearchText: $genreSearchText, isCompleted: $isCompleted, genreList: $genreList, genre: $genre, genreId: $genreId)
}
