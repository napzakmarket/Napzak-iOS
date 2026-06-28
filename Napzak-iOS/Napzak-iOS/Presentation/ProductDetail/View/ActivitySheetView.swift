//
//  ActivitySheetView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 6/22/26.
//

import SwiftUI
import UIKit

struct ActivitySheetView: UIViewControllerRepresentable {
    let activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    let onComplete: (UIActivity.ActivityType?, Bool) -> Void

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )

        controller.completionWithItemsHandler = { activityType, completed, returnedItems, error in
            onComplete(activityType, completed)
        }

        return controller
    }

    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: Context
    ) { }
}
