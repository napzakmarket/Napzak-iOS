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

    let tags = ["산리오", "운혼", "주술회전", "귀멸의 칼날", "사카모토데이즈", "디즈니/픽사"]

    var body: some View {
        ScrollView {
            VStack {
                HeaderView()
                ProfileImageSection()
                MarketNameView(isPrimaryButtonEnabled: $isPrimaryButtonEnabled)
                MarketDescriptionSection(description: $profileDescription)
                GenreSelectionSection(tags: tags, selectedTags: $selectedTags)
                ConfirmButton(isEnabled: isPrimaryButtonEnabled)
            }
        }
    }
}

struct HeaderView: View {
    var body: some View {
        HStack {
            Image(systemName: "chevron.left")
                .foregroundColor(Color.napzakGrayScale(.gray200))
                .padding(.vertical, 4)
                .padding(.horizontal, 7)
            Text("프로필 편집")
                .applyNapzakFont(.body1Bold16)
                .foregroundColor(Color.napzakGrayScale(.gray400))
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct ProfileImageSection: View {
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(Color.napzakGrayScale(.gray100))
                    .padding(.top, 20)
                    .padding(.bottom, 70)
                
                Image("profile_edit")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 110, height: 110)
                    .foregroundColor(.gray)
                    .padding(.top, 180)
                    .offset(x: 5, y: -35)
                
                ZStack {
                    Image("edit")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                }
                .padding(.top, 180)
                .offset(x: 55, y: -15)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct MarketNameView: View {
    @Binding var isPrimaryButtonEnabled: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("마켓 이름")
                .applyNapzakFont(.body5SemiBold14)
                .foregroundColor(Color.napzakGrayScale(.gray400))
            
            Text("띄어쓰기 없이 한글, 영문, 숫자만 사용할 수 있어요 (최대 20자)")
                .applyNapzakFont(.caption5Regular10)
                .foregroundColor(Color.napzakGrayScale(.gray300))
            
            UsernameInputField(isPrimaryButtonEnabled: $isPrimaryButtonEnabled)
                .padding(.top, 10)

        }
        .padding(.horizontal, 20)
        
        Rectangle()
            .fill(Color.napzakGrayScale(.gray10))
            .frame(height: 4)
            .padding(.bottom, 30)
    }
    
}

struct MarketDescriptionSection: View {
    @Binding var description: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("마켓 소개")
                .applyNapzakFont(.body5SemiBold14)
                .foregroundColor(Color.napzakGrayScale(.gray400))
            
            Text("어떤 장르를 좋아하고, 판매하는지! 덕후력을 뽐내는 소개를 작성해주세요")
                .applyNapzakFont(.caption5Regular10)
                .foregroundColor(Color.napzakGrayScale(.gray300))
            
            DescriptionEditor(description: $description, maxLength: 200)
            
            Text("\(description.count)/200")
                .font(.caption)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top,14)
        }
        .padding(.horizontal, 20)
        
        Rectangle()
            .fill(Color.napzakGrayScale(.gray10))
            .frame(height: 4)
            .padding(.top, 27)
    }
}

struct DescriptionEditor: View {
    @Binding var description: String
    let maxLength: Int
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $description)
                .padding(10)
                .scrollContentBackground(.hidden)
                .background(Color.napzakGrayScale(.gray50))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .frame(height: 150)
                .onChange(of: description) { newValue in
                    if newValue.count > maxLength {
                        description = String(newValue.prefix(maxLength))
                    }
                }

            if description.isEmpty {
                Text("어떤 장르를 좋아하고, 판매하는지!\n덕후력을 뽐내는 소개를 작성해주세요")
                    .applyNapzakFont(.caption2Medium12)
                    .foregroundColor(Color.napzakGrayScale(.gray200))
                    .padding(.vertical,14)
                    .padding(.horizontal,17)
            }
        }
        .padding(.top,20)
    }
}

struct GenreSelectionSection: View {
    let tags: [String]
    @Binding var selectedTags: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("관심 장르")
                .applyNapzakFont(.body5SemiBold14)
                .foregroundColor(Color.napzakGrayScale(.gray400))
            Text("최대 7개 선택 가능")
                .applyNapzakFont(.caption5Regular10)
                .foregroundColor(Color.napzakGrayScale(.gray300))
                
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 3),
                GridItem(.flexible(), spacing: 3),
                GridItem(.flexible(), spacing: 3)
            ], alignment: .leading, spacing: 8) {
                ForEach(["산리오", "은혼", "주술회전", "귀멸의 칼날", "시카모리", "디즈니/픽사"], id: \.self) { tag in
                    Text(tag)
                        .foregroundColor(Color.napzakPrimary(.purple500))
                        .applyNapzakFont(.caption1SemiBold12)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 38)
                                .stroke(Color.napzakPrimary(.purple500), lineWidth: 1)
                        )
                        .cornerRadius(38)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button("관심 장르 설정") {}
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.napzakGrayScale(.gray50))
                .applyNapzakFont(.body4Bold14)
                .foregroundColor(Color.napzakGrayScale(.gray400))
                .cornerRadius(14)
                .padding(.top, 20)
        }
        .padding(.horizontal,27)
        .padding(.top,27)
    }
}

struct ConfirmButton: View {
    var isEnabled: Bool = false
    
    var body: some View {
        Button(action: {}) {
            Text("확인")
                .frame(maxWidth: .infinity)
                .padding()
                .background(isEnabled ? Color.napzakPrimary(.purple500) : Color.napzakPrimary(.purple500).opacity(0.5))
                .applyNapzakFont(.body4Bold14)
                .foregroundColor(Color.napzakGrayScale(.white))
                .cornerRadius(14)
        }
        .disabled(!isEnabled)
        .padding(.bottom, 63)
        .padding(.horizontal,27)
        .padding(.top,10)
    }
}

// MARK: - Preview
struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditView()
    }
}
