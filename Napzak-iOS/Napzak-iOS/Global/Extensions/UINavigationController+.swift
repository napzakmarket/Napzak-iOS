//
//  UINavigationController+.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/14/25.
//

import UIKit

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return SwipePopGestureManager.shared.isAllowPopGesture && viewControllers.count > 1
    }
}
