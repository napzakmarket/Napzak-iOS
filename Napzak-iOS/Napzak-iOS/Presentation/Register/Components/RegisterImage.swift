//
//  RegisterImage.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/8/25.
//

import SwiftUI

struct RegisterImage: View {
    @ObservedObject var imagePickerManager : ImagePickerManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("상품 이미지")
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .frame(height: 18)
                .padding(.bottom, 4)
            
            Text("꾹 눌러서 대표 이미지를 변경할 수 있어요")
                .applyNapzakFont(.caption2Medium12)
                .foregroundStyle(Color.napzakGrayScale(.gray300))
                .frame(height: 15)
                .padding(.bottom, 8)
            
            selectImageSection
        }
    }
    
    private var selectImageSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .bottom, spacing: 0) {
                imagePickerManager.photoPickerView {
                    VStack(spacing: 0) {
                        Spacer()
                        Image(.iconPhotoPicker)
                            .frame(width: 24, height: 24)
                            .padding(.bottom, 5)
                        Text("사진 \(imagePickerManager.selectedImageCount())/10")
                            .foregroundStyle(Color.napzakPrimary(.purple500))
                            .applyNapzakFont(.caption3Regular12)
                            .frame(height: 13)
                            .padding(.bottom, 18)
                    }
                    .frame(width: 88, height: 88)
                    .background(Color.napzakPrimary(.purple100))
                    .clipShape(.rect(cornerRadius: 5))
                    .padding(.trailing, 14)
                }
                .disabled(imagePickerManager.isDisabled)
                
                ForEach(0..<imagePickerManager.selectedImages.count, id: \.self) { index in
                    imageItemView(for: index)
                        .padding(.trailing, 8)
                }
            }
        }
        .frame(height: 96)
    }
    
    @ViewBuilder
    private func imageItemView(for index: Int) -> some View {
        ZStack(alignment: .bottomLeading) {
            Image(uiImage: imagePickerManager.selectedImages[index])
                .resizable()
                .scaledToFill()
                .frame(width: 88, height: 88)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay(alignment: .topLeading) {
                    if index == 0 {
                        representativeBadge
                    }
                }
            deleteButton(at: index)
        }
        .frame(width: 95, height: 96)
    }
    
    private func deleteButton(at index: Int) -> some View {
        VStack {
            HStack {
                Spacer()
                Image(.iconImageCancle)
                    .frame(width: 16, height: 16)
                    .onTapGesture {
                        imagePickerManager.deleteImage(at: index)
                    }
            }
            Spacer()
            Color.clear
                .frame(width: 88)
                .frame(maxHeight: .infinity)
                .contentShape(Rectangle())
                .onLongPressGesture {
                    imagePickerManager.moveImageToFront(at: index)
                }
        }
    }
    
    private var representativeBadge: some View {
        VStack {
            Text("대표")
                .applyNapzakFont(.caption5Regular10)
                .foregroundStyle(.white)
                .frame(height: 13)
        }
        .frame(width: 46, height: 23)
        .background(Color.napzakTransparency(.transBlack))
        .clipShape(
            .rect(topLeadingRadius: 5, bottomTrailingRadius: 5)
        )
    }
}
