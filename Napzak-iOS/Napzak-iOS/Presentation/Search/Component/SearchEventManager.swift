//
//  SearchEventManager.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 6/16/25.
//

import Combine

final class SearchEventManager {
    static let shared = SearchEventManager()
    
    private init() {}

    let searchCompleted = PassthroughSubject<String, Never>()
}

