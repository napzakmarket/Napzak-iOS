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
}

extension HomeBannersModel {
    static let sample = HomeBannersModel(
        topBanners: [
            BannerItem(
                id: 1,
                imageURL: "https://kream-phinf.pstatic.net/MjAyNTA0MjVfMjk1/MDAxNzQ1NTQ1MTgzMTM0.eHhgML5dpkPJnXpqjJA0hSNkp4N0h92D8sj6umUPsrYg.nVsPcqjNdwXqI2TCYxkxv-rltS1n4UaRM_JnboJvYBQg.JPEG/a_ec9cddf6aa83486199ce983afb4cd922.jpg",
                action: .genre(id: 1)
            ),
            BannerItem(
                id: 2,
                imageURL: "https://kream-phinf.pstatic.net/MjAyNTA0MjRfMTE1/MDAxNzQ1NDg1MTE4NDAz.x5oe6s5ZD7nSY43_r-ZZCk2_e2UPW686CBdlmL6tC8Ig.F_n_phMvuU_UbSINCTA60QDYy9e3K6_swj9duKKt9AUg.JPEG/a_569512a10c84429d8e31a85c797bd00e.jpg?type=m_2560_webp",
                action: .external(url: "https://napzak.com/event1")
            ),
            BannerItem(
                id: 3,
                imageURL: "https://kream-phinf.pstatic.net/MjAyNTA0MjVfMjk1/MDAxNzQ1NTQ1MTgzMTM0.eHhgML5dpkPJnXpqjJA0hSNkp4N0h92D8sj6umUPsrYg.nVsPcqjNdwXqI2TCYxkxv-rltS1n4UaRM_JnboJvYBQg.JPEG/a_ec9cddf6aa83486199ce983afb4cd922.jpg",
                action: .genre(id: 2)
            )
        ],
        middleBanner: BannerItem(
            id: 4,
            imageURL: "https://kream-phinf.pstatic.net/MjAyNTA0MjVfMjk1/MDAxNzQ1NTQ1MTgzMTM0.eHhgML5dpkPJnXpqjJA0hSNkp4N0h92D8sj6umUPsrYg.nVsPcqjNdwXqI2TCYxkxv-rltS1n4UaRM_JnboJvYBQg.JPEG/a_ec9cddf6aa83486199ce983afb4cd922.jpg",
            action: .external(url: "https://napzak.com/event2")
        ),
        bottomBanner: BannerItem(
            id: 5,
            imageURL: "https://kream-phinf.pstatic.net/MjAyNTA0MjVfMjk1/MDAxNzQ1NTQ1MTgzMTM0.eHhgML5dpkPJnXpqjJA0hSNkp4N0h92D8sj6umUPsrYg.nVsPcqjNdwXqI2TCYxkxv-rltS1n4UaRM_JnboJvYBQg.JPEG/a_ec9cddf6aa83486199ce983afb4cd922.jpg",
            action: .none
        )
    )
}
