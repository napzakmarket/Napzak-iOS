//
//  TextField+.swift
//  Napzakm-iOS
//
//  Created by 조혜린 on 3/14/25.
//

import SwiftUI

extension TextField {
    
    ///글자 수 제한
    func maxLength(_ length: Int, text: Binding<String>) -> some View {
        self
            .onChange(of: text.wrappedValue) { newValue in
                if newValue.count > length {
                    text.wrappedValue = String(newValue.prefix(length))
                }
            }
    }
    
}
