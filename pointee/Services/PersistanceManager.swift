//
//  PersistanceManager.swift
//  pointee
//
//  Created by Alexander on 20.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation
import KeychainSwift

protocol Persistable {
    func getEncryptedObject<C: Codable>(with key: String) -> C?
    func saveEncryptedObject<C: Codable>(with key: String, object: C)
    func getAuthToken(with key: String) -> String?
    func saveAuthToken(with key: String, token: String?)
    func clearAllObjects()
    func getObject<C: Codable>(with key: String) -> C?
    func saveObject<C: Codable>(with key: String, object: C)
    func readData<T>(forKey: String) -> T?
    func readData<T>(forKey: String, defaultValue: T) -> T
    func writeData<T>(forKey: String, value: T?)
    func removeData(forKey key: String)
}

struct PersistanceManager {
    static let defaultPersistance: Persistable = { return LocalStoreManager.shared }()
}

/// Local Store Manager
final class LocalStoreManager: UserDefaults, Persistable {
    
    static let shared = LocalStoreManager()
        
    private let keychain = KeychainSwift()
    
    func getAuthToken(with key: String) -> String? {
        return keychain.get(key)
    }
    
    func saveAuthToken(with key: String, token: String?) {
        guard let value = token else {
            print("**** REMOVING KEY \(key)")
            keychain.delete(key)
            return
        }
        keychain.set(value, forKey: key)
        print("**** PERSISTING VALUE \(String(describing: value)), FOR KEY \(key)")
    }
    
    /// Get Object from Keychaine
    func getEncryptedObject<C: Codable>(with key: String) -> C? {
        guard let data: Data = keychain.getData(key) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(C.self, from: data)
    }

    /// Save Object to Keychaine
    func saveEncryptedObject<C: Codable>(with key: String, object: C) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(object) {
            keychain.set(data, forKey: key)
        }
    }
    
    /// Delete all Objects in Keychaine
    func clearAllObjects() {
        print("**** Clear All Objects")
        keychain.clear()
    }
    
    func getObject<C: Codable>(with key: String) -> C? {
        guard let data: Data = readData(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(C.self, from: data)
    }

    func saveObject<C: Codable>(with key: String, object: C) {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(object)
        writeData(forKey: key, value: data)
    }
    
    func readData<T>(forKey key: String) -> T? {
        if let data = object(forKey: key) {
            return data as? T
        }
        return nil
    }

    func readData<T>(forKey key: String, defaultValue: T) -> T {
        if let data = readData(forKey: key) as T? {
            return data
        }
        return defaultValue
    }

    func writeData<T>(forKey key: String, value: T?) {
        print("**** PERSISTING VALUE \(String(describing: value)), FOR KEY \(key)")
        guard let value = value else {
            removeData(forKey: key)
            return
        }
        set(value, forKey: key)
        synchronize()
    }
        
    func removeData(forKey key: String) {
        print("**** REMOVING KEY \(key)")
        removeObject(forKey: key)
    }
}
