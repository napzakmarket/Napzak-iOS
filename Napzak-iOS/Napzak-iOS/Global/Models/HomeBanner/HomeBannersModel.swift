//
//  HomeBannersModel.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/28/25.
//

import Foundation

struct HomeBannersModel {
    var topBanners: [BannerItem]
    var middleBanner: BannerItem
    var bottomBanner: BannerItem
    
    init(topBanners: [BannerItem], middleBanner: BannerItem, bottomBanner: BannerItem) {
        self.topBanners = topBanners
        self.middleBanner = middleBanner
        self.bottomBanner = bottomBanner
    }
    
    init?(dto: BannerData) {
        guard let middle = dto.MiddleBannerList.first,
              let bottom = dto.BottomBannerList.first else {
            return nil
        }
        
        self.topBanners = dto.TopBannerList.map { BannerItem(dto: $0) }
        self.middleBanner = BannerItem(dto: middle)
        self.bottomBanner = BannerItem(dto: bottom)
    }
    
    static let empty = HomeBannersModel(
        topBanners: [],
        middleBanner: .empty,
        bottomBanner: .empty
    )
}
