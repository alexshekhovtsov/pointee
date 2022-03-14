//
//  AuthenticationData.swift
//  pointee
//
//  Created by Alexander on 20.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

/**
   AccountHolder Model
*/
struct AuthenticationData: Codable, Equatable {
    /// User FirstName
    var name: String = ""
    /// User LastName
    var email: String = ""
    /// Phone
    var phone: String = ""
    /// User ID
    let userId: String
    /// Access Token
    let accessToken: String
    /// Token Type
    let tokenType: String
    /// Is User Registered
    let isRegistered: Bool
    
    // MARK: - Initialize
    
    /**
     Initialize AuthenticationData
     - name: String
     - email: String
     - userId: String
     - accessToken: String
     - tokenType: String
     - isRegistered: Bool
     @return An initialized AuthenticationData instance.
     */
    init(name: String,
         email: String,
         phone: String,
         userId: String,
         accessToken: String,
         tokenType: String,
         isRegistered: Bool) {
        self.name = name
        self.email = email
        self.phone = phone
        self.userId = userId
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.isRegistered = isRegistered
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let name = try container.decodeIfPresent(String.self, forKey: .name) {
            self.name = name
        }
        if let email = try container.decodeIfPresent(String.self, forKey: .email) {
            self.email = email
        }
        userId = try container.decode(String.self, forKey: .userId)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        tokenType = try container.decode(String.self, forKey: .tokenType)
        isRegistered = try container.decode(Bool.self, forKey: .isRegistered)
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case userId
        case accessToken = "access_token"
        case tokenType = "token_type"
        case isRegistered = "isRegistred"
    }
}
