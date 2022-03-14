//
//  BusinessRepository.swift
//  pointee
//
//  Created by Alexander on 23.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

/**
   Object is responsible for managing Business requests
*/
struct BusinessRepository {
    
    /// ApiClient
    private let apiClient: APIClientMock

    // MARK: - Initialize
    
    /// Initialize BusinessRepository
    /// - Parameter apiClient: ApiClient
    init(apiClient: APIClientMock = APIClientMock()) {
        self.apiClient = apiClient
    }
    
    /// Businesses list
    /// - Parameters:
    ///   - tags: [String]?
    ///   - resultHandler: ResultHandler<BusinessesList>
    func businesses(tags: [String]? = nil, resultHandler: @escaping ResultHandler<BusinessesList>) {
        apiClient.call(handler: resultHandler)
    }
    
    /// Business with id
    /// - Parameters:
    ///   - id: String
    ///   - resultHandler: ResultHandler<Business>
    func business(with id: String, resultHandler: @escaping ResultHandler<Business>) {
        apiClient.call(handler: resultHandler)
    }
    
    /// Assortment of business with id
    /// - Parameters:
    ///   - id: String
    ///   - resultHandler: ResultHandler<Categories>
    func assortment(with businessID: String, resultHandler: @escaping ResultHandler<Categories>) {
        apiClient.call(handler: resultHandler)
    }
    
    /// Products of category with id
    /// - Parameters:
    ///   - id: String
    ///   - resultHandler: ResultHandler<Products>
    func products(with categoryID: String, resultHandler: @escaping ResultHandler<Products>) {
        apiClient.call(handler: resultHandler)
    }
    
    /// Add to Favorites business with id
    /// - Parameters:
    ///   - id: String
    ///   - resultHandler: ResultHandler<Void>
    func addFavorite(with businessID: String, resultHandler: @escaping ResultHandler<Void>) {
        apiClient.callNoResult(handler: resultHandler)
    }
}
