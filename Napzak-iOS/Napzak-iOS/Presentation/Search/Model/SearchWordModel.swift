//
//  SearchWordModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 5/11/25.
//

import Foundation

struct SearchWordModel: Identifiable {
    let id: Int
    let searchWord: String
    
    //MARK: Init

    ///default init
    init(id: Int, searchWord: String) {
        self.id = id
        self.searchWord = searchWord
    }
    
    ///init for decoding
    init(dto: SearchWordDTO) {
        self.id = dto.searchWordId
        self.searchWord = dto.searchWord
    }
}
