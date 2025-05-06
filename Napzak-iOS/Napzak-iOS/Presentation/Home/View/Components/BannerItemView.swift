//
//  BannerItemView.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/28/25.
//

import SwiftUI
import Kingfisher

struct BannerItemView: View {
    let banner: BannerItem
    var style: bannerStyle = .large
    let onTap: () -> Void
    
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    private var bannerWidth: CGFloat {
        switch style {
        case .large:
            return screenWidth
        case .small:
            return screenWidth - 56
        }
    }

    var body: some View {
        KFImage(URL(string: banner.imageURL))
            .resizable()
            .placeholder {
                Color.napzakGrayScale(.gray50)
            }
            .retry(maxCount: 3, interval: .seconds(5))
            .onFailure { error in
                print("failure: \(error.localizedDescription)")
            }
            .aspectRatio(contentMode: .fill)
            .frame(width: bannerWidth)
            .frame(height: style.height)
            .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
            .clipped()
            .contentShape(Rectangle())
            .onTapGesture {
                onTap()
            }
    }
}

extension BannerItemView {
    enum bannerStyle {
        case large
        case small(cornerRadius: CGFloat = 0)
        
        var height: CGFloat {
            switch self {
            case .large:
                return 216
            case .small:
                return 110
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .large:
                return 0
            case .small(let radius):
                return radius
            }
        }
    }
}
