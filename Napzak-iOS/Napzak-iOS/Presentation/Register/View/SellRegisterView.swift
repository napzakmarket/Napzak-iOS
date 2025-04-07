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
                VStack(spacing: 0) {
                    RegisterImageSection()
                        .padding(.top, 30)
                        .padding(.horizontal, 28)
                        .padding(.bottom, 27)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    RegisterGenreSection()
                        .padding(.horizontal, 18)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 21)
                    
                    Rectangle()
                        .fill(Color.napzakGrayScale(.gray10))
                        .frame(height: 4)
                        .padding(.bottom, 29)
                    
                    RegisterTitleSection()
                        .padding(.horizontal, 28)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 10)
                    
                    RegisterDescriptionSection()
                        .padding(.horizontal, 28)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 23)
                    
                    Rectangle()
                        .fill(Color.napzakGrayScale(.gray10))
                        .frame(height: 4)
                        .padding(.bottom, 23)

                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .frame(maxWidth: .infinity)
        
    }
}

#Preview {
    SellRegisterView()
}





