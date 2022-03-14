//
//  Category.swift
//  pointee
//
//  Created by Alexander on 25.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

typealias Categories = [Category]

struct Category: Codable {
    let id: String
    let title: String
    let imageURL: String
    let subcategories: [Category]?
    let status: CategoryStatus?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case imageURL = "image_url"
        case subcategories
        case status
    }
}

enum CategoryStatus: String, Codable, CodingKey {
    case enabled
    case temporaryDisabled = "temporary_disabled"
    case hidden
}
