//
//  BannerResponseDTO.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/10/25.
//

import Foundation

typealias BannerResponseDTO = BaseResponseDTO<BannerData>

struct BannerData: Decodable {
    let TopBannerList: [BannerDTO]
    let MiddleBannerList: [BannerDTO]
    let BottomBannerList: [BannerDTO]
}

struct BannerDTO: Decodable {
    let bannerId: Int
    let bannerPhoto: String
    let bannerUrl: String
    let bannerSequence: Int
    let isExternal: Bool
}
