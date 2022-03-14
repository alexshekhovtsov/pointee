//
//  FilterModels.swift
//  pointee
//
//  Created by Alexander on 07.05.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

struct BusinessTypeFilter: Codable {
    let type: BusinessType
    var active: Bool
    
    mutating func toggle() {
        active = !active
    }
}

struct CurrentFilters: Codable {
    var tags: [String]
    var cuisines: [String]
}

struct AverageCheckValues: Codable {
    let min: Int
    let max: Int
}

enum OrderFilter {
    case distance
    case rating
    case title
}

extension OrderFilter {
    var toString: String {
        switch self {
        case .distance:
            return R.string.localizable.by_distance()
        case .rating:
            return R.string.localizable.by_rating()
        case .title:
            return R.string.localizable.alphabetically()
        }
    }
}
