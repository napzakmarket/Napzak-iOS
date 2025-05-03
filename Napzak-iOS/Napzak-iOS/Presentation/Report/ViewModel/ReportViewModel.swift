//
//  ReportViewModel.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/28/25.
//

import SwiftUI

import os

final class ReportViewModel: ObservableObject {
    
    // MARK: - Property Wrappers
    
    @Published var reportModel: ReportModel = ReportModel()
    @Published var reasonExpanded: Bool = false
    @Published var showToast: Bool = false
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "Report")
    
    let reportDescriptionPlaceholder = "어떤 일이 있었나요? 💬 \n\n자세한 설명일수록 빠른 해결에 도움이 됩니다. \n신고 내용은 비공개로 안전하게 처리되니 안심하세요. \n안전한 거래 공간을 함께 만들어가요!"
    
    var reportDescriptionCountText: String {
        "\(reportModel.reportDescription.count)"
    }
}


// MARK: - Validation

extension ReportViewModel {
    var reportValidate: Bool {
        let selectedReasonValid = !reportModel.selectedReason.trimmingCharacters(in: .whitespaces).isEmpty
        let reportDescriptionValid = !reportModel.reportDescription.trimmingCharacters(in: .whitespaces).isEmpty
        let contactAddressValid = !reportModel.contactAddress.trimmingCharacters(in: .whitespaces).isEmpty
        
        return selectedReasonValid && reportDescriptionValid && contactAddressValid
    }
}


// MARK: - Network

extension ReportViewModel {
    func report(type: ReportType, id: Int) async {
        let requestData = ReportRequestDTO(
            reportTitle: reportModel.selectedReason,
            reportDescription: reportModel.reportDescription,
            reportContact: reportModel.contactAddress
        )

        switch type {
        case .product:
            let result = await NetworkService.shared.reportService
                .postProductReport(productId: id, requestData: requestData)

            switch result {
            case .success(let response):
                logger.info("📦 [Product Report] message: \(response.message)")
                logger.info("📦 [Product Report] title: \(response.data.reportTitle)")
                logger.info("📦 [Product Report] description: \(response.data.reportDescription)")
                logger.info("📦 [Product Report] contact: \(response.data.reportContact)")
                logger.info("📦 [Product Report] reportedProductID: \(response.data.reportedProductID)")
                logger.info("📦 [Product Report] reporterId: \(response.data.reporterId)")
            case .failure(let error):
                logger.error("❌ Product report failed: \(error.localizedDescription)")
            }

        case .store:
            let result = await NetworkService.shared.reportService
                .postStoreReport(storeId: id, requestData: requestData)

            switch result {
            case .success(let response):
                logger.info("🏬 [Store Report] message: \(response.message)")
                logger.info("🏬 [Store Report] title: \(response.data.reportTitle)")
                logger.info("🏬 [Store Report] description: \(response.data.reportDescription)")
                logger.info("🏬 [Store Report] contact: \(response.data.reportContact)")
                logger.info("🏬 [Store Report] reportedStoreId: \(response.data.reportedStoreId)")
                logger.info("🏬 [Store Report] reporterId: \(response.data.reporterId)")
            case .failure(let error):
                logger.error("❌ Store report failed: \(error.localizedDescription)")
            }
        }
    }
}
