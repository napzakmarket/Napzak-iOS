//
//  AnalyticsEventName.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/21/26.
//

import Foundation

public enum AnalyticsEventName: String {
    // 온보딩 (Onboarding)
    case signedUp = "Signed Up"
    case completedOnboarding = "Completed Onboarding"
    case skippedGenres = "Skipped Genres"
    
    // 홈 (Home)
    case viewedHome = "Viewed Home"
    case clickedBanner = "Clicked Banner"
    case viewedPopularWanted = "Viewed Popular Wanted"
    case viewedPopularForSale = "Viewed Popular For Sale"
    case clickedCustomGenre = "Clicked custom genre"
    
    // 탐색 (Explore)
    case viewedExplore = "Viewed Explore"
    case appliedGenreFilter = "Applied Genre Filter"
    case appliedArrayFilter = "Applied array Filter"
    case viewedProduct = "Viewed Product"
    case startedChat = "Started Chat"
    case viewedSearchResult = "Viewed Search Result"
    
    // 검색 (Search)
    case openedSearch = "Opened Search"
    case executedSearch = "Executed Search"
    case clickedSuggestion = "Clicked Suggestion"
    
    // 포스팅 (Posting)
    case createdPost = "Created Post"
    
    // 설정/마이페이지 (Settings, MyPage)
    case viewedMypage = "Viewed MyPage"
    case viewedSettings = "Viewed Settings"
    case toggledAlarm = "Toggled Alarm"
    case startedWithdrawal = "Started Withdrawal"
    case completedWithdrawal = "Completed Withdrawal"
    case loggedOut = "Logged Out"
    
    // 신고 및 기타 (Report, Global)
    case toggledWishlist = "Toggled Wishlist"
    case itemLiked = "Item Liked"
    case itemStatusUpdated = "Item Status Updated"
    case openedReportOverlayMarket = "Opened Report Overlay_market"
    case openedReportOverlayProduct = "Opened Report Overlay_product"
    case submittedReportMarket = "Submitted Report_market"
    case submittedReportProduct = "Submitted Report_product"
    
    public var value: String { self.rawValue }
}
