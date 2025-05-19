//
//  ImagePickerManager.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/3/25.
//

import SwiftUI

import PhotosUI

final class ImagePickerManager: ObservableObject {
    
    private struct ImageResult {
        let index: Int
        let image: UIImage
        let identifier: String
    }
    
    var onImageSelectionCompleted: (([UIImage]) -> Void)?
    
    @Published var selectedImages: [UIImage] = []
    @Published var imageNameList: [String] = []
    @Published var photosPickerItem: [PhotosPickerItem] = [] {
        didSet {
            Task {
                await handlePhotoPickerChange()
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
    
    @MainActor
    func deleteImage(at index: Int) {
        selectedImages.remove(at: index)
        imageNameList.remove(at: index)
    }
    
    @MainActor
    func moveImageToFront(at index: Int) {
        let movedImage = selectedImages.remove(at: index)
        let movedName = imageNameList.remove(at: index)
        selectedImages.insert(movedImage, at: 0)
        imageNameList.insert(movedName, at: 0)
    }
    
    func handlePhotoPickerChange() async {
        guard !isProcessing else { return }
        isProcessing = true
        defer { isProcessing = false }

        let limit = max(0, maxSelectedCount - selectedImages.count)
        let itemsToProcess = Array(photosPickerItem.prefix(limit))

        let processed = await loadAndDecode(items: itemsToProcess)

        await MainActor.run {
            for result in processed {
                selectedImages.append(result.image)
                imageNameList.append(result.identifier)
            }
            photosPickerItem.removeAll()
            onImageSelectionCompleted?(selectedImages)
        }
    }

    private func loadAndDecode(items: [PhotosPickerItem]) async -> [ImageResult] {
        await withTaskGroup(of: ImageResult?.self) { group in
            for (index, item) in items.enumerated() {
                
                group.addTask(priority: .userInitiated) {
                    guard
                      let data = try? await item.loadTransferable(type: Data.self),
                      let image  = UIImage(data: data)
                    else { return nil }
                    return ImageResult(index: index, image: image, identifier: UUID().uuidString)
                }
            }
            var results = [ImageResult]()
            for await optionalImageResult in group {
                if let imageResult = optionalImageResult {
                    results.append(imageResult)
                }
            }
            return results.sorted { $0.index < $1.index }
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
