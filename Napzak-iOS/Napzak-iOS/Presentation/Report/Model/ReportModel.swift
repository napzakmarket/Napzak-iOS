//
//  ReportModel.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/29/25.
//

import SwiftUI

enum ReportType {
    case product
    case store
    
    var title: String {
        switch self {
        case .product:
            return "상품"
        case .store:
            return "마켓"
        }
    }
    
    var reportReasons: [String] {
        switch self {
        case .product:
            return [
                ReportReasonMessage.prohibitedProduct,
                ReportReasonMessage.inappropriateContent,
                ReportReasonMessage.includefalseInfoOrAd,
                ReportReasonMessage.offensiveLanguage,
                ReportReasonMessage.dispute,
                ReportReasonMessage.other
            ]
        case .store:
            return [
                ReportReasonMessage.badManners,
                ReportReasonMessage.suspectedFraud,
                ReportReasonMessage.offensiveLanguage,
                ReportReasonMessage.dispute,
                ReportReasonMessage.other
            ]
        }
    }
}

struct ReportModel {
    var selectedReason: String = ""
    var reportDescription: String = ""
    var contactAddress: String = ""
}
