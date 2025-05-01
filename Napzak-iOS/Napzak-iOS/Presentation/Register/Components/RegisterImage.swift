//
//  RegisterImage.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/8/25.
//

import SwiftUI
import PhotosUI

struct RegisterImage: View {
    @Binding var selectedImages: [UIImage]
    
    @Binding var imageNameList: [String]
    
    @Binding var presignedUrls: [String]
    
    @State private var photosPickerItem: [PhotosPickerItem] = []
    
    private let maxSelectedCount = 10
    
    private var disabled: Bool {
        selectedImages.count >= maxSelectedCount
    }
    
    private var availableSelectedCount: Int {
        maxSelectedCount - selectedImages.count
    }
    
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
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .bottom, spacing: 0) {
                    PhotosPicker(
                        selection: $photosPickerItem,
                        maxSelectionCount: availableSelectedCount,
                        selectionBehavior: .ordered,
                        matching: .images
                    ) {
                        VStack{
                            Image(.iconPhotoPicker)
                                .frame(width: 24, height: 24)
                            
                            Text("사진 0/10")
                                .applyNapzakFont(.caption3Regular12)
                                .foregroundStyle(Color.napzakPrimary(.purple500))
                                .frame(height: 13)
                        }
                        .frame(width: 88, height: 88)
                        .background(Color.napzakPrimary(.purple100))
                        .clipShape(.rect(cornerRadius: 5))
                        .padding(.trailing, 14)
                    }
                    .disabled(disabled)
                    
                    ForEach(0..<selectedImages.count, id: \.self) { index in
                        imageItemView(for: index)
                            .padding(.trailing, 8)
                    }
                }
                
            }
            .frame(height: 96)

            
        }
        .onChange(of: photosPickerItem) { _ in
            handlePhotoPickerChange()
        }
    }
}

// MARK: - Functions

extension RegisterImage {
    
    // 자잘한 세팅 수정
    private var representativeBadge: some View {
        VStack(alignment: .center) {
            Text("대표")
                .applyNapzakFont(.caption5Regular10)
                .foregroundStyle(.white)
                .frame(height: 13)
        }
        .frame(width: 46, height: 23)
        .background(Color.napzakTransparency(.transBlack))
        .clipShape(
            .rect(
                topLeadingRadius: 5,
                bottomTrailingRadius: 5
            )
        )
    }
    
    private func imageItemView(for index: Int) -> some View {
        
        ZStack(alignment: .bottomLeading) {
            Image(uiImage: selectedImages[index])
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
        VStack{
                HStack{
                    
                    Spacer()
                    
                    Image(.iconImageCancle)
                        .frame(width: 16, height: 16)
                        .onTapGesture {
                            print("xbutton tapped")
                            selectedImages.remove(at: index)
                            imageNameList.remove(at: index)
                        }
                }
            
            Spacer()
            
            Rectangle()
                .fill(.gray.opacity(0.000000000000000000001))
                .frame(width: 88)
                .frame(maxHeight: .infinity)
                .onLongPressGesture(perform: {
                    print("picture long pressed")
                    moveImageToFront(at: index)
                })
        }
        
        
    }
    
    private func handlePhotoPickerChange() {
        Task {
            for item in photosPickerItem {
                if let data = try? await item.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: data) {
                        selectedImages.append(image)
                        imageNameList.append(UUID().uuidString)
                    }
                }
            }
            
            photosPickerItem.removeAll()
        }
    }
    
    private func moveImageToFront(at index: Int) {
        let movedImage = selectedImages.remove(at: index)
        imageNameList.remove(at: index)
        selectedImages.insert(movedImage, at: 0)
        imageNameList.insert(UUID().uuidString, at: 0)
    }
    
}


