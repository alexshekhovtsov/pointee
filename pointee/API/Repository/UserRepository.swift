//
//  UserRepository.swift
//  pointee
//
//  Created by Alexander on 23.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

/**
   Object is responsible for managing User data
*/
struct UserRepository {
    
    /// ApiClient
    private let apiClient: APIClientMock

    // MARK: - Initialize
    
    /// Initialize UserRepository
    /// - Parameter apiClient: ApiClient
    init(apiClient: APIClientMock = APIClientMock()) {
        self.apiClient = apiClient
    }
    
    /// Get Current User Data
    /// - Parameter resultHandler: ResultHandler<User>
    func getCurrentUser(resultHandler: @escaping ResultHandler<User>) {
        apiClient.call(handler: resultHandler)
    }
    
    /// Get Current User Favorites
    /// - Parameter resultHandler: ResultHandler<User>
    func getFavorites(resultHandler: @escaping ResultHandler<BusinessesList>) {
        apiClient.call(handler: resultHandler)
    }
    
    /// Get Current Filters Can Be Used In App
    /// - Parameter resultHandler: ResultHandler<CurrentFilters>
    func getFilters(resultHandler: @escaping ResultHandler<CurrentFilters>) {
        apiClient.call(handler: resultHandler)
    }
}
