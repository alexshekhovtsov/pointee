//
//  BusinessType.swift
//  pointee
//
//  Created by Alexander on 24.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

enum BusinessType: String, CodingKey, Codable, CaseIterable {
    case shop
    case cafe
}

extension BusinessType {

    var filterDescription: String {
        switch self {
        case .cafe:
            return R.string.localizable.cafes_and_restaurants()
        case .shop:
            return R.string.localizable.shops()
        }
    }
}
