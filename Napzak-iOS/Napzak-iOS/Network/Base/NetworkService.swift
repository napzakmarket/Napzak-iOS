//
//  NetworkService.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/28/25.
//

import Foundation

final class NetworkService {
    
    static let shared = NetworkService()
    
    private init() { }
    
    let authService: AuthServiceProtocol = AuthService()
    let tokenRefreshService: TokenRefreshServiceProtocol = TokenRefreshService()
    let genreService: GenreServiceProtocol = GenreService()
    let storeService: StoreServiceProtocol = StoreService()
    let presignedService: PresignedServiceProtocol = PresignedService()
    let productService: ProductServiceProtocol = ProductService()
    let interestService: InterestServiceProtocol = InterestService()
    let reportService: ReportServiceProtocol = ReportService()
    let homeService: HomeServiceProtocol = HomeService()
    let pushService: PushServiceProtocol = PushService()
    let chatService: ChatServiceProtocol = ChatService()
}
