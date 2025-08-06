//
//  Comparable.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 8/6/25.
//

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
