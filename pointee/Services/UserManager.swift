//
//  UserManager.swift
//  pointee
//
//  Created by Alexander on 01.05.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

let kCurrentUserKey = "kCurrentUserKey"

final class UserManager {
    
    static let shared = UserManager()
    
    private(set) var persistance: Persistable
    private(set) var repository: UserRepository
    
    private init(persistance: Persistable = PersistanceManager.defaultPersistance,
                 repository: UserRepository = UserRepository(apiClient: APIClientMock(filename: "User",
                                                                                      modelType: User.self))) {
        self.persistance = persistance
        self.repository = repository
    }
    
    private var currentUser: User?
    
    var user: User? {
        if let current = currentUser {
            return current
        }
        if let saved: User = persistance.getEncryptedObject(with: kCurrentUserKey) {
            currentUser = saved
        }
        return currentUser
    }
    
    func configureUser(with authData: AuthenticationData) {
        let user = User(name: authData.name,
                        email: authData.email,
                        phone: authData.phone,
                        userID: authData.userId,
                        isRegistered: authData.isRegistered)
        persistUser(user)
    }
    
    func persistUser(_ user: User) {
        persistance.saveEncryptedObject(with: kCurrentUserKey, object: user)
        currentUser = user
    }
    
    func save() {
        persistance.saveEncryptedObject(with: kCurrentUserKey, object: currentUser)
    }
    
    func hasFavoriteBusiness(with id: String) -> Bool {
        guard let _ = user?.favoritesBusiness.first(where: { $0 == id }) else { return false }
        return true
    }
    
    func refresh(_ refreshHandler: ResultHandler<User>? = nil) {
        repository.getCurrentUser(resultHandler: { [weak self] (result) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let accountHolder):
                    self.persistUser(accountHolder)
                    if let refreshHandler = refreshHandler {
                        refreshHandler(.success((accountHolder)))
                    }
                case .error(let error):
                    if let refreshHandler = refreshHandler {
                        refreshHandler(.error(error))
                    }
                }
            }
        })
    }
}
