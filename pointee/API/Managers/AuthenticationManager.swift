//
//  AuthenticationManager.swift
//  pointee
//
//  Created by Alexander on 20.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

/// Key for persisting the authToken
private let kAuthTokenKey = "authToken"
/// Key for persisting the guestToken
private let kGuestTokenKey = "kGuestTokenKey"

/**
    Class is responsible for Persisting Authentication Data
 */
final class AuthenticationManager {
    
    /// Shared Instance
    static let shared = AuthenticationManager()
    
    /// Current Persistable Object
    private var persistance: Persistable
    
    // MARK: - Initialize

    /// Initialize AuthenticationManager
    /// - Parameter persistance: PersistanceManager
    init(persistance: Persistable = PersistanceManager.defaultPersistance) {
        self.persistance = persistance
    }
    
    /// User Auth Token
    var authToken: String? {
        set { persistance.saveAuthToken(with: kAuthTokenKey, token: newValue) }
        get { return persistance.getAuthToken(with: kAuthTokenKey) }
    }
    
    /// Guest Token
    var guestToken: String? {
        set { persistance.saveAuthToken(with: kGuestTokenKey, token: newValue) }
        get { return persistance.getAuthToken(with: kGuestTokenKey) }
    }
    
    /// Is User Logged In
    func isLoggedIn() -> Bool {
        guard let authToken = authToken else { return false }
        if authToken.isEmpty { return false }
        return true
    }
    
    /// Is User Guested
    func isGuested() -> Bool {
        guard let guestToken = guestToken else { return false }
        if guestToken.isEmpty { return false }
        return true
    }
    
    /// Is User Logged In
    func isUserEmpty() -> Bool {
        return !isLoggedIn() && !isGuested()
    }
    
    /// Login with AuthData
    /// - Parameter authenticationData: AuthenticationData
    func loginWith(authenticationData: AuthenticationData) {
        if authenticationData.isRegistered {
            authToken = authenticationData.accessToken
        } else {
            guestToken = authenticationData.accessToken
        }
    }
    
    /// Guest with AuthData
    /// - Parameter authenticationData: AuthenticationData
    func guestWith(authenticationData: AuthenticationData) {
        guestToken = authenticationData.accessToken
    }
    
    /// Log Out and Delete all Auth Data
    @objc
    func logout() {
        authToken = nil
        guestToken = nil
        persistance.clearAllObjects()
    }
}
