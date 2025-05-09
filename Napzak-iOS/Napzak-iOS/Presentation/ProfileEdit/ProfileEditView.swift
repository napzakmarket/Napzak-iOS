//
//  ProfileEditView.swift
//  Napzak-iOS
//
//  Created by 어진 on 4/24/25.
//

import SwiftUI

struct ProfileEditView: View {
    @State private var nickname: String = ""
    @State private var profileDescription: String = ""
    @State private var selectedTags: [String] = []
    @State private var isPrimaryButtonEnabled: Bool = false
    @State private var isGenreSelectModalPresented: Bool = false
    @State private var adaptedGenres: [GenreNameModel] = []
    @EnvironmentObject private var navigationRouter: NavigationRouter

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 0) {
                    headerView
                    profileImageSection
                    marketNameView
                    marketDescriptionSection
                    genreSelectionSection
                    confirmButton
                }
            }
            
            if isGenreSelectModalPresented {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isGenreSelectModalPresented = false
                        }
                    }
                
                GenreSelectModalView(
                    viewModel: GenreSelectModalViewModel(
                        selectedGenres: adaptedGenres
                    ),
                    isGenreSelectModalPresented: $isGenreSelectModalPresented,
                    adaptedGenres: $adaptedGenres
                )
            }
        }
        .animation(.easeInOut, value: isGenreSelectModalPresented)
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarHidden(true)
    }
}

extension ProfileEditView {
    private var headerView: some View {
        HStack(spacing: 3) {
            Button{
                navigationRouter.pop()
            } label: {
                Image(.iconBack)
                    .foregroundColor(Color.napzakGrayScale(.gray200))
                    .frame(width: 24, height: 24)
            }
            Text("프로필 편집")
                .applyNapzakFont(.body1Bold16)
                .foregroundColor(Color.napzakGrayScale(.gray400))
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
    }
    
    private var profileImageSection: some View {
        VStack(spacing: 0) {
            ZStack {
                Rectangle()
                    .fill(Color.napzakGrayScale(.gray100))
                    .frame(height: 160)
                
                Image("profile_edit")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 110, height: 110)
                    .foregroundColor(.gray)
                    .offset(y: 57)
                
                Button {
                    // 사진 편집 기능
                } label: {
                    Image("edit")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                }
                .offset(x: 50, y: 80)
            }
        }
    }
    
    private var marketNameView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("마켓 이름")
                .applyNapzakFont(.body5SemiBold14)
                .foregroundColor(Color.napzakGrayScale(.gray400))
                .padding(.top, 42)
            
            Text("띄어쓰기 없이 한글, 영문, 숫자만 사용할 수 있어요 (최대 20자)")
                .applyNapzakFont(.caption5Regular10)
                .foregroundColor(Color.napzakGrayScale(.gray300))
                .padding(.bottom,16)

            UsernameInputField(isPrimaryButtonEnabled: $isPrimaryButtonEnabled)
                .padding(.top, 10)
                .padding(.bottom,20)
        }
        .padding(.horizontal, 20)
        
        .background(
            VStack {
                Spacer()
                Rectangle()
                    .fill(Color.napzakGrayScale(.gray10))
                    .frame(height: 4)
                    .padding(.bottom, 30)
            }
        )
    }
    
    private var marketDescriptionSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("마켓 소개")
                .applyNapzakFont(.body5SemiBold14)
                .foregroundColor(Color.napzakGrayScale(.gray400))
               
            Text("어떤 장르를 좋아하고, 판매하는지! 덕후력을 뽐내는 소개를 작성해주세요")
                .applyNapzakFont(.caption5Regular10)
                .foregroundColor(Color.napzakGrayScale(.gray300))
               
            descriptionEditor
               
            Text("\(profileDescription.count)/200")
                .applyNapzakFont(.caption4SemiBold10)
                .foregroundColor(Color.napzakGrayScale(.gray300))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 14)
                .padding(.bottom, 30)
        }
        .padding(.horizontal, 20)
           
        .background(
            VStack {
                Spacer()
                Rectangle()
                    .fill(Color.napzakGrayScale(.gray10))
                    .frame(height: 4)
            }
        )
    }
    
    private var descriptionEditor: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $profileDescription)
                .applyNapzakFont(.caption2Medium12)
                .padding(10)
                .scrollContentBackground(.hidden)
                .background(Color.napzakGrayScale(.gray50))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .frame(height: 150)
                .onChange(of: profileDescription) { newValue in
                    if newValue.count > 200 {
                        profileDescription = String(newValue.prefix(200))
                    }
                }

            if profileDescription.isEmpty {
                Text("어떤 장르를 좋아하고, 판매하는지!\n덕후력을 뽐내는 소개를 작성해주세요")
                    .applyNapzakFont(.caption2Medium12)
                    .foregroundColor(Color.napzakGrayScale(.gray200))
                    .padding(.vertical, 14)
                    .padding(.horizontal, 17)
            }
        }
        .padding(.top, 20)
    }
    
    private var genreSelectionSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("관심 장르")
                .applyNapzakFont(.body5SemiBold14)
                .foregroundColor(Color.napzakGrayScale(.gray400))
                .padding(.top,27)
            Text("최대 7개 선택 가능")
                .applyNapzakFont(.caption5Regular10)
                .foregroundColor(Color.napzakGrayScale(.gray300))
                .padding(.bottom,16)
            
            PlainChipContainerView(
                titles: ["산리오", "은혼", "주술회전", "귀멸의 칼날", "사카모토데이즈", "디즈니/픽사"],
                action: { title in
                    if selectedTags.contains(title) {
                        selectedTags.removeAll { $0 == title }
                    } else {
                        if selectedTags.count < 7 {
                            selectedTags.append(title)
                        }
                    }
                }
            )
            .padding(.bottom,25)

            Button {
                withAnimation {
                    isGenreSelectModalPresented = true
                }
            } label: {
                Text("관심 장르 설정")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.napzakGrayScale(.gray50))
                    .applyNapzakFont(.body4Bold14)
                    .foregroundColor(Color.napzakGrayScale(.gray400))
                    .cornerRadius(14)
            }
        }
        .padding(.horizontal, 27)
    }
    
    private var confirmButton: some View {
        Button {
            // 확인 버튼
        } label: {
            Text("확인")
                .frame(maxWidth: .infinity)
                .padding()
                .background(isPrimaryButtonEnabled ? Color.napzakPrimary(.purple500) : Color.napzakPrimary(.purple500).opacity(0.5))
                .applyNapzakFont(.body4Bold14)
                .foregroundColor(Color.napzakGrayScale(.white))
                .cornerRadius(14)
        }
        .disabled(!isPrimaryButtonEnabled)
        .padding(.bottom, 63)
        .padding(.horizontal, 27)
        .padding(.top, 5)
    }
}

// MARK: - Preview

struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditView()
    }
}
