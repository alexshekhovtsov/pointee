//
//  OrderRepository.swift
//  pointee
//
//  Created by Alexander on 23.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

/**
   Object is responsible for managing Orders data
*/
struct OrderRepository {
    
    /// ApiClient
    private let apiClient: APIClientMock

    // MARK: - Initialize
    
    /// Initialize OrderRepository
    /// - Parameter apiClient: ApiClient
    init(apiClient: APIClientMock = APIClientMock()) {
        self.apiClient = apiClient
    }
    
    /// Get Current Orders Data
    /// - Parameter resultHandler: ResultHandler<Orders>
    func getUserOrders(resultHandler: @escaping ResultHandler<Orders>) {
        apiClient.call(handler: resultHandler)
    }
    
    func getCurrentOrders(resultHandler: @escaping ResultHandler<Orders>) {
        apiClient.call(handler: resultHandler)
    }
}
