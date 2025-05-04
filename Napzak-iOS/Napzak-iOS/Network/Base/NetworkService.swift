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
    
    let genreService: GenreServiceProtocol = GenreService()
    let storeService: StoreServiceProtocol = StoreService()
    let presignedService: PresignedServiceProtocol = PresignedService()
    let productService: ProductServiceProtocol = ProductService()
    let interestService: InterestServiceProtocol = InterestService()

}
