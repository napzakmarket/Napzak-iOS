//
//  CarouselView.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/29/25.
//

import SwiftUI

struct CarouselView: View {
    @Binding var currentPage: Int
    let banners: [BannerItem]
    var onTapBanner: ((BannerItem) -> Void)? = nil
    
    @State private var timerPaused = false
    @GestureState private var isDragging = false
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    private var displayBanners: [BannerItem] {
        guard let first = banners.first, let last = banners.last else { return [] }
        
        if banners.count == 1 {
            return [last] + banners + [first]
        } else {
            return [last] + banners + banners + banners + [first]
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentPage) {
                ForEach(0..<displayBanners.count, id: \.self) { index in
                    BannerItemView(banner: displayBanners[index]) {
                        onTapBanner?(displayBanners[index])
                        print("배너 눌림")
                    }
                    .tag(index)
                    .simultaneousGesture(
                        DragGesture()
                            .updating($isDragging) { _, state, _ in
                                state = true
                                timerPaused = true
                            }
                            .onEnded { _ in
                                timerPaused = false
                            }
                    )
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 216)
            .onChange(of: currentPage) { newValue in
                handleInfiniteScroll(newValue)
            }
            
            indicatorView
                .padding(.bottom, 16)
                .contentShape(Rectangle())
        }
        .onAppear {
            if banners.count > 1 && currentPage == 0 {
                currentPage = 1
            }
        }
        .onReceive(timer) { _ in
            guard !timerPaused && !banners.isEmpty && !isDragging else { return }
            withAnimation(.easeInOut(duration: 0.3)) {
                if currentPage == displayBanners.count - 1 {
                    currentPage = 1
                } else {
                    currentPage += 1
                }
            }
        }
    }
}

extension CarouselView {
    private var indicatorView: some View {
        HStack(spacing: 8) {
            ForEach(0..<banners.count, id: \.self) { index in
                indicatorCircle(for: index)
            }
        }
    }
    
    private func indicatorCircle(for index: Int) -> some View {
        let isCurrentPage = index == (currentPage - 1) % banners.count
        let fillColor = isCurrentPage ? Color.napzakPrimary(.purple500) : Color.napzakGrayScale(.gray100)
        
        return Circle()
            .fill(fillColor)
            .frame(width: 7, height: 7)
            .onTapGesture {
                withAnimation(.easeInOut) {
                    currentPage = index + 1
                }
            }
    }
}

extension CarouselView {
    private func handleInfiniteScroll(_ newValue: Int) {
        if newValue == displayBanners.count - 1 {
            Task {
                try? await Task.sleep(for: .seconds(0.3))
                    currentPage = 1
            }
        } else if newValue == 0 {
            Task {
                try? await Task.sleep(for: .seconds(0.3))
                    currentPage = displayBanners.count - 2
            }
        }
    }
}

#Preview {
    struct PreviewContainer: View {
        @State var currentPage: Int = 1
        
        var body: some View {
            CarouselView(
                currentPage: $currentPage,
                banners: [
                    BannerItem(id: 1, imageURL: "https://kream-phinf.pstatic.net/MjAyNTA0MjVfMjk1/MDAxNzQ1NTQ1MTgzMTM0.eHhgML5dpkPJnXpqjJA0hSNkp4N0h92D8sj6umUPsrYg.nVsPcqjNdwXqI2TCYxkxv-rltS1n4UaRM_JnboJvYBQg.JPEG/a_ec9cddf6aa83486199ce983afb4cd922.jpg", action: .none),
                    BannerItem(id: 2, imageURL: "https://kream-phinf.pstatic.net/MjAyNTA0MjRfMTE1/MDAxNzQ1NDg1MTE4NDAz.x5oe6s5ZD7nSY43_r-ZZCk2_e2UPW686CBdlmL6tC8Ig.F_n_phMvuU_UbSINCTA60QDYy9e3K6_swj9duKKt9AUg.JPEG/a_569512a10c84429d8e31a85c797bd00e.jpg?type=m_2560_webp", action: .none),
                    BannerItem(id: 3, imageURL: "https://kream-phinf.pstatic.net/MjAyNTA0MjVfMjk1/MDAxNzQ1NTQ1MTgzMTM0.eHhgML5dpkPJnXpqjJA0hSNkp4N0h92D8sj6umUPsrYg.nVsPcqjNdwXqI2TCYxkxv-rltS1n4UaRM_JnboJvYBQg.JPEG/a_ec9cddf6aa83486199ce983afb4cd922.jpg", action: .none)
                ],
                onTapBanner: { banner in
                    print("Tapped Banner ID: \(banner.id)")
                }
            )
        }
    }
        
    return PreviewContainer()
}
