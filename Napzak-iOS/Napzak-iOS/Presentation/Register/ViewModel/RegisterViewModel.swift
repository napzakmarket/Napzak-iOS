//
//  RegisterViewModel.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/29/25.
//

import SwiftUI

import os

enum RegisterViewType {
    case initialRegister
    case editProduct(productID: Int, tradeType: TradeType)
}

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
    
    init(viewType: RegisterViewType)  {
        imagePickerManager.onImageSelectionCompleted = { [weak self] images in
            self?.model.images = images
        }
        
        Task {
            await getAllGenre()
        }
        
        switch viewType {
        case .initialRegister:
            print("dddd")
        case .editProduct(let productId, let tradeType):
            Task {
                switch tradeType {
                case .sell:
                    await getSellProductInfoForEdit(productId: productId)
                case .buy:
                    await getBuyProductInfoForEdit(productId: productId)
                }
            }
        }

    }
}


// MARK: - Network

extension RegisterViewModel {
    
    
    //MARK: - Get all genre
    
    func getAllGenre() async {
        let result = await NetworkService.shared.genreService.getAllGenreName()
        
        switch result {
        case .success(let response):
            guard let data = response.data else {
                logger.error("❌ getAllGenreName: No data received")
                return
            }
            self.genreList = data.genreList.map { GenreNameModel(dto: $0) }
            
        case .failure(let error):
            logger.error("❌ GET All Genre failed: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Get search genre
    
    func getSearchGenre(searchWord: String) async {
        let result = await NetworkService.shared.genreService.getSearchGenreName(searchWord: searchWord)
        
        switch result {
        case .success(let response):
            guard let data = response.data else {
                logger.error("getSearchGenreName: No data received")
                return
            }
            self.genreList = data.genreList.map { GenreNameModel(dto: $0) }
            
        case .failure(let error):
            logger.error("getSearchGenreName failed: \(error.localizedDescription)")
        }
    }
    
    func getSellProductInfoForEdit(productId: Int) async {
        let result = await NetworkService.shared.productService.getSellProductInfoForEdit(productId: productId)

        switch result {
        case .success(let response):
            guard let data = response.data else {
                logger.error("getSellProductInfoForEdit: No data received")
                return
            }
            self.model = RegisterModel(images: [],
                                       title: data.title,
                                       description: data.description,
                                       price: String(data.price),
                                       genre: data.genreName,
                                       genreId: data.genreId,
                                       productCondition: data.productCondition,
                                       isDeliveryIncluded: data.isDeliveryIncluded,
                                       standardDeliveryFee: String(data.standardDeliveryFee),
                                       halfDeliveryFee: String(data.halfDeliveryFee))
            
        case .failure(let error):
            logger.error("getSellProductInfoForEdit failed: \(error.localizedDescription)")
        }
    }
    
    func getBuyProductInfoForEdit(productId: Int) async {
        let result = await NetworkService.shared.productService.getBuyProductInfoForEdit(productId: productId)

        switch result {
        case .success(let response):
            guard let data = response.data else {
                logger.error("getBuyProductInfoForEdit: No data received")
                return
            }
            self.model = RegisterModel(images: [],
                                       title: data.title,
                                       description: data.description,
                                       price: String(data.price),
                                       genre: data.genreName,
                                       genreId: data.genreId,
                                       isPriceNegotiable: data.isPriceNegotiable ?? false)
            
        case .failure(let error):
            logger.error("getBuyProductInfoForEdit failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - GET presigned url
    
    func getPresignedUrl() async -> Bool {
        let result = await NetworkService.shared.presignedService
            .getPresignedURL(imageNameList: imagePickerManager.imageNameList)
        
        switch result {
        case .success(let response):
            let imageNames = imagePickerManager.imageNameList
            let uploadURL = response.data!.productPresignedUrls
            
            // Simplify URLs before storing
            let simplifiedUploadURL: [String: String] = uploadURL.compactMapValues { simplifyUrl(url: $0) }
            
            self.presignedUrlList = simplifiedUploadURL.filter { key, _ in
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
        // presigned URL 요청
        guard await getPresignedUrl() else { return }
        
        // presigned URL에 이미지 업로드
        guard await putPresignedUrl() else { return }
        
        // 업로드된 이미지 URL → productPhotoList 생성
        let sortedImageNames = imagePickerManager.imageNameList
        let photoList: [SellRegisterRequestPhotoList] = sortedImageNames.enumerated().compactMap { index, name in
            if let url = presignedUrlList[name] {
                return SellRegisterRequestPhotoList(photoUrl: url, sequence: index+1)
            } else {
                logger.error("❌ presignedUrlList에 \(name) 없음")
                return nil
            }
        }
        
        guard let genreId = model.genreId else {
            logger.error("❌ 장르 ID 없음")
            return
        }
        
        let dto = SellRegisterRequestDTO(
            productPhotoList: photoList,
            genreId: genreId,
            title: model.title,
            description: model.description,
            price: model.price.convertInt(),
            productCondition: model.productCondition?.rawValue ?? "",
            isDeliveryIncluded: model.isDeliveryIncluded ?? true,
            standardDeliveryFee: model.standardDeliveryFee.convertInt(),
            halfDeliveryFee: model.halfDeliveryFee.convertInt()
        )
        
        // POST 요청
        let result = await NetworkService.shared.productService.postSellRegister(
            sellRegisterProduct: dto
        )
        
        switch result {
        case .success(let response):
            logger.info("✅ 판매 등록 성공: \(response.data!.productId)")
            self.productId = response.data?.productId
        case .failure(let error):
            logger.error("❌ 판매 등록 실패: \(error.localizedDescription)")
        }
    }
    
    func postBuyRegister() async {
        // presigned URL 요청
        guard await getPresignedUrl() else { return }
        
        // presigned URL에 이미지 업로드
        guard await putPresignedUrl() else { return }
        
        // 업로드된 이미지 URL → productPhotoList 생성
        let sortedImageNames = imagePickerManager.imageNameList
        let photoList: [BuyRegisterRequestPhotoList] = sortedImageNames.enumerated().compactMap { index, name in
            if let url = presignedUrlList[name] {
                return BuyRegisterRequestPhotoList(photoUrl: url, sequence: index+1)
            } else {
                logger.error("❌ presignedUrlList에 \(name) 없음")
                return nil
            }
        }
        
        guard let genreId = model.genreId else {
            logger.error("❌ 장르 ID 없음")
            return
        }
        
        let dto = BuyRegisterRequestDTO(
            productPhotoList: photoList,
            genreId: genreId,
            title: model.title,
            description: model.description,
            price: model.price.convertInt(),
            isPriceNegotiable: model.isPriceNegotiable
        )
        
        // POST 요청
        let result = await NetworkService.shared.productService.postBuyRegister(
            buyRegisterProduct: dto
        )
        
        switch result {
        case .success(let response):
            logger.info("✅ 구매 등록 성공: \(response.data!.productId)")
            self.productId = response.data?.productId
        case .failure(let error):
            logger.error("❌ 구매 등록 실패: \(error.localizedDescription)")
        }
    }
    
    
    // MARK: - url 필요한 부분만 추출하는 로직
    
    func simplifyUrl(url: String) -> String? {
        // URL에서 ? 이전의 도메인과 경로만 추출
        guard let urlComponents = URLComponents(string: url) else {
            return nil
        }
        
        // URL의 도메인과 경로 구성
        var simplifiedUrl = "\(urlComponents.scheme ?? "https")://\(urlComponents.host ?? "")\(urlComponents.path)"
        
        // ? 이후의 쿼리 문자열 제거
        if let queryIndex = simplifiedUrl.firstIndex(of: "?") {
            simplifiedUrl = String(simplifiedUrl[..<queryIndex])
        }
        
        return simplifiedUrl
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
        let conditionValid = model.productCondition?.rawValue.isEmpty == false
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
