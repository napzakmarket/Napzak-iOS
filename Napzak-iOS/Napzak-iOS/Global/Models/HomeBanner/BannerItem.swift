//
//  BannerItem.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/28/25.
//

import Foundation

struct BannerItem: Identifiable {
    let id: Int
    let imageURL: String
    let action: BannerAction
    
    init(id: Int, imageURL: String, action: BannerAction) {
        self.id = id
        self.imageURL = imageURL
        self.action = action
    }
    
    init(dto: BannerDTO) {
        self.id = dto.bannerId
        self.imageURL = dto.bannerPhoto
        
        if dto.isExternal {
            self.action = .external(url: dto.bannerUrl)
        } else {
            self.action = .none
        }
    }
}

extension BannerItem {
    static let empty = BannerItem(
        id: -1,
        imageURL: "",
        action: .none
    )
}
