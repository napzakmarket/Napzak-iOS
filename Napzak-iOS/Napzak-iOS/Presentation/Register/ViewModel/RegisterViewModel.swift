//
//  RegisterViewModel.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/29/25.
//

import SwiftUI

final class RegisterViewModel: ObservableObject {
    
    // MARK: - Property Wrappers
    
    @Published var model: RegisterModel = RegisterModel()
    
    @Published var imageNameList: [String] = []
    @Published var presignedUrlList: [String] = []
    @Published var productId: Int?
    @Published var normalDelivery: Bool = false                     // 일반 배달비 선택 여부
    @Published var halfDelivery: Bool = false                       // 알뜰,반값 배달비 선택 여부
    @Published var priceError: Bool = false
    @Published var maxPrice: Int = 1_000_000       // 최대 금액 100만원
    @Published var addPrices = ["+1,000원", "+5,000원", "+10,000원", "+100,000원"]
    @Published var genreSearchText = ""
    @Published var isCompleted: Bool = false
    @Published var genreList: [GenreNameModel] = []
    
    
    init() {
        fetchGenre(genreSearchText: genreSearchText)
    }
    
}

//MARK: - Network

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
