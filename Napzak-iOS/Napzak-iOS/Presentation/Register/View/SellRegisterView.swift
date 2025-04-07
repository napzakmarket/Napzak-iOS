//
//  SellRegisterView.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/8/25.
//

import SwiftUI

struct SellRegisterView: View {
    var body: some View {
        VStack{
            SellRegisterHeader()
            
            ScrollView {
                RegisterImageSection()
                    .padding(.top, 30)
                    .padding(.horizontal, 28)
                
                
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
    }
}

#Preview {
    SellRegisterView()
}

