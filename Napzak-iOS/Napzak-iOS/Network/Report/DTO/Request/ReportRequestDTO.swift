//
//  ReportRequestDTO.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/4/25.
//

import SwiftUI

struct ReportRequestDTO: Encodable {
    let reportTitle: String
    let reportDescription: String
    let reportContact: String
}
