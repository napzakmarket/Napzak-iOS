//
//  ZoomableImageView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 7/22/25.
//

import SwiftUI

import Kingfisher

struct ZoomableImageView: View {
    
    //MARK: - Property Wrappers

    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var anchor: UnitPoint = .center

    //MARK: - Properies
    
    let imageUrl: URL
    
    //MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            KFImage(imageUrl)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(scale, anchor: anchor)
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            scale = lastScale * value
                        }
                        .onEnded { _ in
                            lastScale = scale.clamped(to: 1.0...5.0)
                            withAnimation {
                                scale = lastScale
                            }
                        }
                )
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let globalPoint = value.location
                            let frame = geometry.frame(in: .global)
                            
                            let x = (globalPoint.x - frame.minX) / frame.width
                            let y = (globalPoint.y - frame.minY) / frame.height
                            anchor = UnitPoint(x: x, y: y)
                        }
                )
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
                .animation(.easeInOut(duration: 0.2), value: scale)
        }
    }
}
