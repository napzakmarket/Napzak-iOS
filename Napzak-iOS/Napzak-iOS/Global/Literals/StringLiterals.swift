//
//  StringLiterals.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/22/25.
//

import SwiftUI

struct ReportReasonMessage {
    static let prohibitedProduct = "거래 금지 상품을 판매하고 있어요"
    static let inappropriateContent = "부적절한 콘텐츠를 포함하고 있어요"
    static let includefalseInfoOrAd = "허위/과장 정보 및 광고를 포함하고 있어요"
    static let badManners = "비매너 마켓이에요"
    static let suspectedFraud = "사기 행위가 의심돼요"
    static let offensiveLanguage = "욕설/비속어 등 불쾌한 표현을 사용했어요"
    static let dispute = "거래 과정에서 분쟁이 발생했어요"
    static let other = "기타 문제가 있어요"
}

struct WithdrawReasonMessage {
    static let hardToFindGoods = "원하는 굿즈를 찾기 어려워요"
    static let poorSales = "상품이 잘 안팔려요"
    static let inconvenientApp = "앱이 사용하기 불편해요"
    static let encounteredRudeUser = "비매너 사용자를 만났어요"
    static let wantNewAccount = "새 마켓(계정)을 만들고 싶어요"
    static let privacyConcerns = "개인정보 보호가 걱정돼요"
    static let noLongerInterested = "더 이상 덕질 활동을 하지 않아요"
    static let other = "다른 이유가 있어요"
}
