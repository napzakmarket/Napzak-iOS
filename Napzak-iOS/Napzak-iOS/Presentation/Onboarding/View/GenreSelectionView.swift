//
//  GenreSelectionView.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/7/25.
//

import SwiftUI

struct GenreSelectionView: View {
    @StateObject private var viewModel = GenreSelectionViewModel()
    @FocusState private var isSearchFocused: Bool
    @State private var isSearchCompleted: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            OnboardingNavigationBar(step: 3)
            
            headerView
                .zIndex(2)
            
            ZStack(alignment: .bottom) {
                contentView
                    .animation(.easeInOut(duration: 0.3), value: viewModel.selectedGenres)
                
                LinearGradient(
                    gradient: Gradient(colors: [
                        .white.opacity(0),
                        .white
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.bottom)
                .frame(height: 108)
                .frame(maxWidth: .infinity)
                .allowsHitTesting(false)
                
                bottomButtonView
                    .padding(.horizontal, 20)
            }
            .zIndex(1)
            .ignoresSafeArea(.keyboard)
            
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if isSearchFocused {
                isSearchFocused = false
            }
        }
    }
}

extension GenreSelectionView {
    private var headerView: some View {
        Group {
            Text("최대 7개 선택")
                .applyNapzakFont(.caption1SemiBold12)
                .foregroundStyle(Color.napzakPrimary(.purple500))
                .padding(.top, 11)
            
            Text("어떤 장르를 좋아하시나요?\n취향에 딱 맞는 상품을 소개해드릴게요")
                .lineLimit(2)
                .applyNapzakFont(.title2Bold20)
                .foregroundStyle(Color.napzakGrayScale(.gray400))
                .padding(.top, 10)
            
            Text("장르 선택은 많을수록 좋아요.\n숨겨진 레어템을 발견할 기회를 놓치지 마세요!")
                .applyNapzakFont(.caption3Regular12)
                .foregroundStyle(Color.napzakGrayScale(.gray300))
                .padding(.top, 10)
            
            SearchBar(
                placeholder: "원하는 장르를 직접 검색해보세요!",
                text: $viewModel.searchText,
                isCompleted: $isSearchCompleted,
                isFocused: _isSearchFocused
            )
            .padding(.top, 20)
        }
        .padding(.horizontal, 20)
    }
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 0) {
            if !viewModel.selectedGenres.isEmpty {
                ChipsContainerView(selectedGenres: Binding(
                    get: {
                        return viewModel.selectedGenres.map { preferGenre in
                            return GenreName(id: preferGenre.id, name: preferGenre.name)
                        }
                    },
                    set: { newGenreNames in
                        viewModel.selectedGenres = newGenreNames.compactMap { genreName in
                            return viewModel.genres.first { $0.id == genreName.id }
                        }
                    }
                ))
                .frame(height: 30)
                .padding(.top, 15)
                .transition(.move(edge: .top).combined(with: .opacity))
                .padding(.horizontal, 20)
            }
            
            ZStack(alignment: .top) {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.gray.opacity(0.15),
                        Color.gray.opacity(0.05),
                        Color.gray.opacity(0.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 8)
                
                GenreGridView(
                    genres: $viewModel.genres,
                    selectedGenres: $viewModel.selectedGenres,
                    onGenreSelected: { genre in
                        viewModel.toggleGenreSelection(genre)
                    }
                )
                .padding(.horizontal, 20)
            }
            .padding(.top, 16)
        }
    }
    
    private var bottomButtonView: some View {
        VStack(spacing: 16) {
            if viewModel.showToast {
                ToastMessageView(message: "관심 장르는 최대 7개까지만 고를 수 있어요")
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            Button {
                // TODO: 유저 장르 등록
                print("납작마켓 시작하기")
            } label: {
                Text("납작마켓 시작하기")
                    .applyNapzakFont(.body4Bold14)
                    .foregroundStyle(Color.napzakGrayScale(.white))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(getStartButtonColor())
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(viewModel.selectedGenres.isEmpty)
            
            Button {
                print("건너뛰기")
            } label: {
                Text("건너뛰기")
                    .applyNapzakFont(.caption2Medium12)
                    .foregroundStyle(Color.napzakGrayScale(.gray300))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.showToast)
    }
}

extension GenreSelectionView {
    private func getStartButtonColor() -> Color {
        return viewModel.selectedGenres.isEmpty
        ? Color.napzakGrayScale(.gray100)
        : Color.napzakPrimary(.purple500)
    }
}

#Preview {
    GenreSelectionView()
}
