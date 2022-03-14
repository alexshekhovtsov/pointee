//
//  User.swift
//  pointee
//
//  Created by Alexander on 01.05.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

class User: Codable {
    /// User FirstName
    let name: String
    /// User LastName
    let email: String
    /// Phone
    let phone: String?
    /// User ID
    let userID: String
    /// Is User Registered
    let isRegistered: Bool
    /// Favorite organizations
    var favoritesBusiness: Set<String>
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case userID = "user_id"
        case isRegistered = "is_registered"
        case favoritesBusiness = "favorites_business"
    }
    
    init(name: String,
         email: String, 
         phone: String?, 
         userID: String, 
         isRegistered: Bool, 
         favoritesBusiness: Set<String> = []) {
        self.name = name
        self.email = email
        self.phone = phone
        self.userID = userID
        self.isRegistered = isRegistered
        self.favoritesBusiness = favoritesBusiness
    }
}
