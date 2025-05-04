//
//  RegisterViewModel.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/29/25.
//

import SwiftUI

import os

@MainActor
final class RegisterViewModel: ObservableObject {
    
    // MARK: - Instance
    
    @Published var model: RegisterModel = RegisterModel()
    @Published var imagePickerManager = ImagePickerManager()
    
    // MARK: - Property Wrappers
    
    @Published var presignedUrlList: [String:String] = [:]
    @Published var productId: Int?
    @Published var normalDelivery: Bool = false
    @Published var halfDelivery: Bool = false
    @Published var priceError: Bool = false
    @Published var maxPrice: Int = 1_000_000
    @Published var addPrices = ["+1,000원", "+5,000원", "+10,000원", "+100,000원"]
    @Published var genreSearchText = ""
    @Published var isCompleted: Bool = false
    @Published var genreList: [GenreNameModel] = []
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "Register")
    
    init() {
        imagePickerManager.onImageSelectionCompleted = { [weak self] images in
            self?.model.images = images
        }
        fetchGenre(genreSearchText: genreSearchText)
    }
    
}


// MARK: - Network

extension RegisterViewModel {
    
    
    // MARK: - GET presigned url

    func getPresignedUrl() async -> Bool {
        let result = await NetworkService.shared.presignedService
            .getPresignedURL(imageNameList: imagePickerManager.imageNameList)
        
        switch result {
        case .success(let response):
            let imageNames = imagePickerManager.imageNameList
            let statusCode = response.status
            let message = response.message
            let uploadURL = response.data.productPresignedUrls
            
            logger.info("✅ Status Code: \(statusCode)")
            logger.info("✅ Message: \(message)")
            logger.info("✅ \(uploadURL)")
            
            self.presignedUrlList = uploadURL.filter { key, _ in
                imageNames.contains(key)
            }
            
            return true
            
        case .failure(let error):
            logger.error("❌ GET Presigned URL failed: \(error.localizedDescription)")
            return false
        }
    }
    
    
    // MARK: - PUT presigned url

    func putPresignedUrl() async -> Bool {
        guard presignedUrlList.count == imagePickerManager.selectedImages.count else {
            logger.error("❌ presignedUrlList와 이미지 수 불일치")
            return false
        }

        let imageNames = imagePickerManager.imageNameList
        let urls = presignedUrlList
        var uploadResults = Array(repeating: false, count: imageNames.count)

        await withTaskGroup(of: (Int, Bool).self) { group in
            for (index, name) in imageNames.enumerated() {
                guard let url = urls[name],
                      index < imagePickerManager.selectedImages.count,
                      let imageData = imagePickerManager.selectedImages[index].jpegData(compressionQuality: 0.8) else {
                    logger.error("❌ 이미지 또는 URL 매칭 실패: \(index+1)번 이미지")
                    continue
                }

                group.addTask {
                    let result = await NetworkService.shared.presignedService.putPresignedURL(url: url, imageData: imageData)
                    switch result {
                    case .success:
                        return (index, true)
                    case .failure(let error):
                        self.logger.error("❌ PUT Presigned URL 실패: \(error.localizedDescription) - \(index+1)번 이미지")
                        return (index, false)
                    }
                }
            }

            for await (index, success) in group {
                uploadResults[index] = success
            }
        }

        if uploadResults.allSatisfy({ $0 }) {
            logger.info("✅ 모든 이미지 업로드 성공")
            return true
        } else {
            logger.error("❌ 일부 이미지 업로드 실패")
            return false
        }
    }
    
    
    // MARK: - POST Register

    func postSellRegister() async {
        guard await getPresignedUrl() else {return}
        guard await putPresignedUrl() else {return}
        
        // post 요청 보내는 로직
        
    }
    
    func postBuyRegister() {
        
    }
    
}




//MARK: - fetchGenre

extension RegisterViewModel {
    func fetchGenre(genreSearchText: String) {
        if genreSearchText.isEmpty {
            //TODO: - 전체 목록 API
            genreList = [GenreNameModel(id: 1, name: "나루토"),
                         GenreNameModel(id: 2, name: "원피스"),
                         GenreNameModel(id: 3, name: "드래곤볼"),
                         GenreNameModel(id: 4, name: "명탐정 코난"),
                         GenreNameModel(id: 5, name: "진격의 거인"),
                         GenreNameModel(id: 6, name: "슬램덩크")]
        } else {
            //TODO: - 검색 목록 API
        }
    }
}


//MARK: - Validation

extension RegisterViewModel {
    var sharedValidate: Bool {
        let titleValid = !model.title.trimmingCharacters(in: .whitespaces).isEmpty
        let descriptionValid = !model.description.trimmingCharacters(in: .whitespaces).isEmpty
        let priceValid = model.price.trimmingCharacters(in: .whitespaces).convertInt() > 0
        let imageValid = !model.images.isEmpty
        let genreSelected = model.genreId != nil
        
        return titleValid && descriptionValid && priceValid && imageValid && genreSelected
    }
    
    var sellRegisterValidate: Bool {
        let conditionValid = !model.productCondition.isEmpty
        return conditionValid && deliveryValidate
    }
    
    var buyRegisterValidate: Bool {
        return true
    }
    
    var deliveryValidate: Bool {
        let isDeliveryIncluded = model.isDeliveryIncluded == true
        let trimmedStandardFee = model.standardDeliveryFee.trimmingCharacters(in: .whitespaces)
        let trimmedHalfFee = model.halfDeliveryFee.trimmingCharacters(in: .whitespaces)
        let isNormalValid = normalDelivery && trimmedStandardFee.convertInt() > 100
        let isHalfValid = halfDelivery && !trimmedHalfFee.isEmpty
        let isAtLeastOneChecked = normalDelivery || halfDelivery
        let allCheckedConditionsValid = (
            (!normalDelivery || isNormalValid) &&
            (!halfDelivery || isHalfValid)
        )
        let isSeparateDeliveryValid = model.isDeliveryIncluded == false &&
        isAtLeastOneChecked &&
        allCheckedConditionsValid
        
        return isDeliveryIncluded || isSeparateDeliveryValid
    }
}
