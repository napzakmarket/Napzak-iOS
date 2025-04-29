//
//  RegisterSearchGenre.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/29/25.
//

import SwiftUI

struct RegisterSearchGenre: View {
    //    @ObservedObject var viewModel: RegisterViewModel
    
    @State var genreSearchText = ""
    @State private var isCompleted: Bool = false
    @State private var genreList: [GenreName] = [GenreName(id: 1, name: "나루토"),
                                                 GenreName(id: 2, name: "원피스"),
                                                 GenreName(id: 3, name: "드래곤볼"),
                                                 GenreName(id: 4, name: "명탐정 코난"),
                                                 GenreName(id: 5, name: "진격의 거인"),
                                                 GenreName(id: 6, name: "슬램덩크")]
    
    var body: some View {
        ZStack(alignment: .top) {
            genreListScrollView
            headerView
        }
        .ignoresSafeArea()
        .background(Color.napzakGrayScale(.gray10))
    }
}

extension RegisterSearchGenre {
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 0){
            Button {
                //TODO: - 뒤로가기
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
                      isCompleted: $isCompleted)
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
            LazyVStack(alignment: .leading) {
                ForEach(genreList, id: \.self){ genre in
                    Button {
                        
                    } label: {
                        Text("\(genre.name)")
                            .applyNapzakFont(.body6Regular14)
                            .foregroundStyle(Color.napzakGrayScale(.gray400))
                            .padding(10)
                    }
                }
            }
            .padding(.top, 15)
            .padding(.bottom, 128)
            .padding(.leading, 18)
            
        }
        .padding(.top, 260)
    }


}

#Preview {
    RegisterSearchGenre()
}


