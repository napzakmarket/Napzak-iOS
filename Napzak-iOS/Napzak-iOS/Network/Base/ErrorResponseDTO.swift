//
//  ErrorResponseDTO.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/9/25.
//

import Foundation

struct ErrorResponseDTO: Decodable {
  let status: Int
  let message: String
}
