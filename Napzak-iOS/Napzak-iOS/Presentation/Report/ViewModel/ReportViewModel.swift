//
//  ReportViewModel.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/28/25.
//

import SwiftUI

final class ReportViewModel: ObservableObject {
    
    // MARK: - Property Wrappers
    
    @Published var reasonExpanded: Bool = false
    @Published var showToast: Bool = false
    @Published var reportModel: ReportModel = ReportModel()
    
    let reportDescriptionPlaceholder = "어떤 일이 있었나요? 💬 \n\n자세한 설명일수록 빠른 해결에 도움이 됩니다. \n신고 내용은 비공개로 안전하게 처리되니 안심하세요. \n안전한 거래 공간을 함께 만들어가요!"
}
