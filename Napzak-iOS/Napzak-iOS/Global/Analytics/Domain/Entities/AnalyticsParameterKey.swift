//
//  AnalyticsParameterKey.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/21/26.
//

import Foundation

public enum AnalyticsParameterKey: String {
    case action = "action"
    case actionType = "action_type"
    case bannerId = "banner_id"
    case bannerIndex = "banner_index"
    case bannerType = "banner_type"
    case filterCount = "filter_count"
    case genreName = "genre_name"
    case genresCategory = "genres_category"
    case genresSelectedCount = "genres_selected_count"
    case itemIndex = "item_index"
    case keyword = "keyword"
    case method = "method"
    case platform = "platform"
    case postId = "post_id"
    case postType = "post_type"
    case reasonSelected = "reason_selected"
    case resultCount = "result_count"
    case searchSource = "search_source"
    case sort = "sort"
    case source = "source"
    case status = "status"
    case statusLabel = "status_label"
    case suggestionIndex = "suggestion_index"
    case suggestionType = "suggestion_type"
    case tab = "tab"
    case targetId = "target_id"
    case targetType = "target_type"
    case userRole = "user_role"
    
    public var name: String { self.rawValue }
}
