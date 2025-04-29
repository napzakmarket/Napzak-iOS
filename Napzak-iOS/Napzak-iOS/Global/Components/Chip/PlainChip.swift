//
//  PlainChip.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/23/25.
//

import SwiftUI

struct PlainChip: View {
    
    //MARK: - Properties
    
    let title: String
    
    //MARK: - body
    
    var body: some View {
        Text(title)
            .applyNapzakFont(.caption1SemiBold12)
            .foregroundStyle(Color.napzakPrimary(.purple500))
            .frame(height: 15)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.napzakPrimary(.purple500), lineWidth: 1)
            )
    }
}

#Preview {
    PlainChip(title: "헌터x헌터 룩업")
}
