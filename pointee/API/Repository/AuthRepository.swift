//
//  AuthRepository.swift
//  pointee
//
//  Created by Alexander on 22.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

/**
   Object is responsible for managing Authentication
*/
struct AuthRepository {
    
    /// ApiClient
    private let apiClient: APIClientMock

    // MARK: - Initialize
    
    /// Initialize AuthRepository
    /// - Parameter apiClient: ApiClient
    init(apiClient: APIClientMock = APIClientMock()) {
        self.apiClient = apiClient
    }
    
    /// Sign In with email and password
    /// - Parameters:
    ///   - email: Double
    ///   - password: Double
    ///   - resultHandler: ResultHandler<AuthenticationData>
    func signIn(email: String, password: String, resultHandler: @escaping ResultHandler<AuthenticationData>) {
        apiClient.call(handler: resultHandler)
    }
    
    /// Sign In with email and password
    /// - Parameters:
    ///   - email: Double
    ///   - password: Double
    ///   - resultHandler: ResultHandler<AuthenticationData>
    func signUp(email: String, password: String, resultHandler: @escaping ResultHandler<AuthenticationData>) {
        apiClient.call(handler: resultHandler)
    }
    
    /// Sign In with email and password
    /// - Parameters:
    ///   - resultHandler: ResultHandler<AuthenticationData>
    func guest(resultHandler: @escaping ResultHandler<AuthenticationData>) {
        apiClient.call(handler: resultHandler)
    }
}
