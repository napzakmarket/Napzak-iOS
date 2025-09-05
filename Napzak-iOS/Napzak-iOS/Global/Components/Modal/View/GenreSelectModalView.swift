//
//  GenreSelectModalView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/21/25.
//

import SwiftUI

struct GenreSelectModalView: View {
    
    //MARK: - Property Wrappers
    
    @StateObject var viewModel: GenreSelectModalViewModel

    @FocusState private var isSearchBarFocused: Bool
    
    @Binding var isGenreSelectModalPresented: Bool
    @Binding var adaptedGenres: [GenreNameModel]
    
    //MARK: - Properties
    
    var onCompleted: ((_ adaptedGenreCount: Int) -> Void)? = nil
    
    //MARK: - Main Body
    
    var body: some View {
        ZStack(alignment: .top) {
            genreListScrollView
            headerView
            applyButtonView
        }
        .clipShape(.rect(topLeadingRadius: 31, topTrailingRadius: 31))
        .padding(.top, 250)
        .onTapGesture {
            isSearchBarFocused = false
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.height > 60 {
                        withAnimation {
                            isGenreSelectModalPresented = false
                        }
                    }
                }
        )
        .animation(.easeInOut, value: viewModel.selectedGenres)
    }
}

extension GenreSelectModalView {
    
    //MARK: - UI Properties
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        isGenreSelectModalPresented = false
                    }
                } label: {
                    Image(.iconCloseModal)
                }
            }
            .padding(.bottom, 20)
            
            Text("장르 선택")
                .applyNapzakFont(.title2Bold20)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .frame(height: 26)
                .padding(.bottom, 2)
            Text("최대 7개 선택")
                .applyNapzakFont(.caption2Medium12)
                .foregroundStyle(Color.napzakPrimary(.purple500))
                .frame(height: 15)
                .padding(.bottom, 25)

            Group {
                SearchBar(
                    placeholder: "어떤 장르의 굿즈인가요? 검색해보세요!",
                    text: $viewModel.inputGenreText,
                    isCompleted: $viewModel.isSearchCompleted,
                    isFocused: _isSearchBarFocused
                )
                .onChange(of: viewModel.inputGenreText) { value in
                    Task {
                        if value.isEmpty {
                            await viewModel.fetchAllGenres()
                        } else {
                            await viewModel.fetchSearchGenres(searchWord: value)
                        }
                    }
                }
                
                if !viewModel.selectedGenres.isEmpty {
                    ChipsContainerView(selectedGenres: $viewModel.selectedGenres)
                        .frame(height: 29)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .padding(.bottom, 23)
        }
        .padding(.horizontal, 27)
        .padding(.top, 18)
        .background(
            Color.napzakGrayScale(.white)
                .shadow(color: .black.opacity(0.1), radius: 4)
        )
    }
    
    private var genreListScrollView: some View {
        ZStack(alignment: .bottom) {
            Color.napzakGrayScale(.gray10)
            
            if viewModel.loadingManager.isLoadingNetwork {
                SpinnerLoadingView()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(alignment: .leading) {
                        ForEach(viewModel.genres, id: \.self){ genre in
                            Button {
                                viewModel.selectGenre(genre)
                            } label: {
                                HStack {
                                    Text("\(genre.name)")
                                        .applyNapzakFont(viewModel.selectedGenres.contains(genre) ? .body5SemiBold14 : .body6Regular14)
                                        .foregroundStyle(viewModel.selectedGenres.contains(genre) ? Color.napzakPrimary(.purple500) : Color.napzakGrayScale(.gray400))
                                        .padding(10)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding(.top, 15)
                    .padding(.bottom, 128)
                    .padding(.leading, 18)
                }
                .padding(.top, viewModel.selectedGenres.isEmpty ? 186 : 235 )
                
                LinearGradient(
                    gradient: Gradient(colors: [
                        .white.opacity(0),
                        .white
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 270)
                .allowsHitTesting(false)
            }
        }
    }
    
    private var applyButtonView: some View {
        VStack {
            Spacer()
            if viewModel.showToast {
                ToastMessageView(
                    message: "관심 장르는 최대 7개까지만 고를 수 있어요",
                    style: .warning
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .padding(.bottom, 30)
            }
            Button {
                adaptedGenres = viewModel.selectedGenres
                onCompleted?(viewModel.selectedGenres.count)
                withAnimation {
                    isGenreSelectModalPresented = false
                }
            } label: {
                Text("적용하기")
                    .applyNapzakFont(.body4Bold14)
                    .foregroundStyle(Color.napzakGrayScale(.white))
                    .frame(maxWidth: .infinity)
            }
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.napzakPrimary(.purple500))
                    .frame(height: 50)
            )
        }
        .padding(.horizontal, 27)
        .padding(.bottom, 63)
        .animation(.easeInOut(duration: 0.3), value: viewModel.showToast)
    }
}

#Preview {
    struct PreviewContainer: View {
        @State private var adaptedGenres: [GenreNameModel] = []
        @State private var isGenreSelectModalPresented = true
        
        var body: some View {
            GenreSelectModalView(
                viewModel: GenreSelectModalViewModel(
                    selectedGenres: adaptedGenres
                ),
                isGenreSelectModalPresented: $isGenreSelectModalPresented,
                adaptedGenres: $adaptedGenres
            )
        }
    }
    
    return PreviewContainer()
}
