//
//  WithDrawResponseDTO.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/12/25.
//

typealias WithDrawResponseDTO = BaseResponseDTO<WithDrawResponseData>

struct WithDrawResponseData: Decodable {
    let storeId: Int
    let withdrawTitle: String
    let withdrawDescription: String?
}
