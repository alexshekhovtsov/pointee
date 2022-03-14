//
//  FilterManager.swift
//  pointee
//
//  Created by Alexander on 06.05.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

let kUserTypeFiltersKey = "kUserTypeFiltersKey"
let kUserTagsFiltersKey = "kUserTagsFiltersKey"
let kUserCuisinesFiltersKey = "kUserCuisinesFiltersKey"
let kUserAllTagsFiltersKey = "kUserAllTagsFiltersKey"
let kUserAllCuisinesFiltersKey = "kUserAllCuisinesFiltersKey"
let kUserFiltersTagsVersionKey = "kUserFiltersTagsVersionKey"

class FilterManager: ProgressLoaderViewable {
    
    static let shared = FilterManager()
    
    private(set) var persistance: Persistable
    private(set) var allTags: [String] = []
    private(set) var allCuisines: [String] = []
    
    /// App Action
    var appAction: PublishSubject<AppAction>?
    
    let averageCheckMinValue: Int = 0
    let averageCheckMaxValue: Int = 1500
    let checkStep: CGFloat = 50
    let minimumCheckDistance: CGFloat = 50
    
    private init(persistance: Persistable = PersistanceManager.defaultPersistance) {
        self.persistance = persistance
        self.averageCheck = BehaviorRelay<AverageCheckValues>(value: AverageCheckValues(min: averageCheckMinValue,
                                                                                        max: averageCheckMaxValue))
        if self.version == 0,
            let tags: [String] = persistance.getEncryptedObject(with: kUserAllTagsFiltersKey),
            let cuisines: [String] = persistance.getEncryptedObject(with: kUserAllCuisinesFiltersKey) {
            allTags = tags
            allCuisines = cuisines
        } else {
            startLoaderAnimating()
            UserRepository(apiClient: APIClientMock(filename: "CurrentFilters",
                                                    modelType: CurrentFilters.self)).getFilters { [weak self] result in
                guard let self = self else { return }
                self.stopLoaderAnimation()
                switch result {
                case .success(let filters):
                    self.allTags = filters.tags
                    self.allCuisines = filters.cuisines
                    persistance.saveEncryptedObject(with: kUserAllTagsFiltersKey, object: filters.tags)
                    persistance.saveEncryptedObject(with: kUserAllCuisinesFiltersKey, object: filters.cuisines)
                case .error(let error):
                    self.appAction?.onNext(.error(message: error.localizableError))
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    let averageCheck: BehaviorRelay<AverageCheckValues>
    
    var version: Int {
        set {
            persistance.saveEncryptedObject(with: kUserFiltersTagsVersionKey, object: newValue)
        }
        get {
            guard let ver: Int = persistance.getEncryptedObject(with: kUserFiltersTagsVersionKey) else { return 0 }
            return ver
        }
    }
    
    private var currenctTypes: [BusinessTypeFilter]?
    
    var typesFilter: [BusinessTypeFilter] {
        if let filters = currenctTypes {
            return filters
        } else {
            if let saved: [BusinessTypeFilter] = persistance.getEncryptedObject(with: kUserTypeFiltersKey) {
                currenctTypes = saved
                return saved
            } else {
                let initial = BusinessType.allCases.map({ BusinessTypeFilter(type: $0, active: true) })
                currenctTypes = initial
                return initial
            }
        }
    }
    
    private var currecntTags: [String]?
    
    var tagsFilter: [String] {
        set {
            currecntTags = newValue
        }
        get {
            if let filters = currecntTags {
                return filters
            } else {
                if let saved: [String] = persistance.getEncryptedObject(with: kUserTagsFiltersKey) {
                    currecntTags = saved
                    return saved
                } else {
                    return []
                }
            }
        }
    }
    
    private var currentCuisines: [String]?
    
    var cuisinesFilter: [String] {
        set {
            currentCuisines = newValue
        }
        get {
            if let filters = currentCuisines {
                return filters
            } else {
                if let saved: [String] = persistance.getEncryptedObject(with: kUserCuisinesFiltersKey) {
                    currentCuisines = saved
                    return saved
                } else {
                    return []
                }
            }
        }
    }
    
    func toggle(_ filter: BusinessTypeFilter) {
        if let index = currenctTypes?.firstIndex(where: { $0.type.rawValue == filter.type.rawValue }) {
            currenctTypes?[index].toggle()
        }
    }
    
    func setDefaults() {
        currenctTypes = BusinessType.allCases.map({ BusinessTypeFilter(type: $0, active: true) })
        averageCheck.accept(AverageCheckValues(min: averageCheckMinValue, max: averageCheckMaxValue))
        currecntTags = []
        currentCuisines = []
    }
}
