//
//  TermsResponseDTO.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/8/25.
//

import Foundation

typealias TermsResponseDTO = BaseResponseDTO<TermsData>

struct TermsData: Decodable {
    let termList: [TermDTO]
}

struct TermDTO: Decodable {
    let termsId: Int
    let termsTitle: String
    let termsUrl: String
}
