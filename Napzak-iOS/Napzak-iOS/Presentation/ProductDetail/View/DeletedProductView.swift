//
//  DeletedProductView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 6/22/26.
//

import SwiftUI

struct DeletedProductView: View {
    
    //MARK: - Properties
    
    let onGoToHomeButtonTapped: () -> Void
    
    //MARK: - Main Body
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            Image(.imgDeletedProduct)
                .padding(.bottom, 10)
            Text("삭제되었거나 더 이상\n존재하지 않는 상품이에요.")
                .applyNapzakFont(.title4SemiBold20)
                .foregroundStyle(Color.napzakGrayScale(.black))
                .multilineTextAlignment(.center)
                .padding(.bottom, 6)
            Text("납작마켓에서 다른 상품을 둘러보세요.")
                .applyNapzakFont(.body7Medium16)
                .foregroundStyle(Color.napzakGrayScale(.gray300))
                .padding(.bottom, 38)
            Button {
                onGoToHomeButtonTapped()
            } label: {
                Image(.btnGoToHome)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.napzakGrayScale(.white))
    }
}

#Preview {
    struct PreviewContainer: View {
        
        var body: some View {
            DeletedProductView(
                onGoToHomeButtonTapped: {
                    print("홈으로 가기 버튼 눌림")
                }
            )
        }
    }
    
    return PreviewContainer()
}
