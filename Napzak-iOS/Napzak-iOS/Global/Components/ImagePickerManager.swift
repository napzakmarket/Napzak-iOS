//
//  ImagePickerManager.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/3/25.
//

import SwiftUI

import PhotosUI

@MainActor
final class ImagePickerManager: ObservableObject {
    
    // model의 이미지와의 동기화를 위한 클로저
    var onImageSelectionCompleted: (([UIImage]) -> Void)?
    
    @Published var selectedImages: [UIImage] = []
    @Published var imageNameList: [String] = []
    @Published var presignedUrlList: [PresignedProductUrlsData] = []
    @Published var photosPickerItem: [PhotosPickerItem] = [] {
        didSet {
            Task {
                handlePhotoPickerChange()
            }
        }
    }
    
    private var isProcessing = false
    private let defaultMaxSelectedCount: Int = 10
    private var overrideMaxCount: Int?
    
    var maxSelectedCount: Int {
        overrideMaxCount ?? defaultMaxSelectedCount
    }
    
    func setOverrideMaxCount(_ count: Int?) {
        overrideMaxCount = count
    }
    
    var isDisabled: Bool {
        selectedImages.count >= maxSelectedCount
    }
    
    var availableSelectedCount: Int {
        maxSelectedCount - selectedImages.count
    }
    
    func selectedImageCount() -> Int {
        return selectedImages.count
    }
    
    func deleteImage(at index: Int) {
        selectedImages.remove(at: index)
        imageNameList.remove(at: index)
    }
    
    func moveImageToFront(at index: Int) {
        let movedImage = selectedImages.remove(at: index)
        let movedName = imageNameList.remove(at: index)
        selectedImages.insert(movedImage, at: 0)
        imageNameList.insert(movedName, at: 0)
    }
    
    func handlePhotoPickerChange() {
        guard !isProcessing else { return }
        isProcessing = true
        
        Task {
            defer { isProcessing = false }
            
            let limit = max(0, maxSelectedCount - selectedImages.count)
            let items = Array(photosPickerItem.prefix(limit))
            let indexedItems = items.enumerated().map { (index, item) in (index, item) }
            var tempResults: [(index: Int, image: UIImage, name: String)] = []
            
            await withTaskGroup(of: (Int, UIImage, String)?.self) { group in
                for (index, item) in indexedItems {
                    group.addTask {
                        if let data = try? await item.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            return (index, image, UUID().uuidString)
                        }
                        print("이미지 업로드 실패")
                        return nil
                    }
                }
                
                for await result in group {
                    if let result = result {
                        tempResults.append(result)
                    }
                }
            }
            
            // 인덱스 기준으로 정렬 - 순서 유지
            let sortedResults = tempResults.sorted { $0.index < $1.index }
            
            for result in sortedResults {
                selectedImages.append(result.image)
                imageNameList.append(result.name)
            }
            
            photosPickerItem.removeAll()
            
            onImageSelectionCompleted?(selectedImages)
        }
    }
}


//MARK: - ViewBuilder

extension ImagePickerManager {
    @ViewBuilder
    func photoPickerView<Content: View>(
        maxCount: Int? = nil,
        @ViewBuilder label: () -> Content
    ) -> some View {
        let remaining = max(0, maxSelectedCount - selectedImages.count)
        
        PhotosPicker(
            selection: bindingPhotosPickerItem,
            maxSelectionCount: remaining,
            selectionBehavior: .ordered,
            matching: .images
        ) {
            label()
        }
        .disabled(selectedImages.count >= maxSelectedCount)
        .onAppear {
            if let maxCount = maxCount {
                self.setOverrideMaxCount(maxCount)
            }
        }
    }
}

extension ImagePickerManager {
    var bindingPhotosPickerItem: Binding<[PhotosPickerItem]> {
        Binding(
            get: { self.photosPickerItem },
            set: { newValue in
                self.photosPickerItem = newValue
            }
        )
    }
}
