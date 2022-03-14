//
//  BusinessLocation.swift
//  pointee
//
//  Created by Alexander on 23.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

typealias BusinessesList = [BusinessLocation]

struct BusinessLocation: Codable, Hashable {
    let id: String
    let latitude: Double
    let longitude: Double
    let title: String
    let logoURL: String
    let previewURL: String?
    let reviewsCount: Int
    let rating: Float
    let currentStatus: BusinessStatus
    let openCloseDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case latitude
        case longitude
        case title
        case logoURL = "logo_url"
        case previewURL = "preview_url"
        case reviewsCount = "reviews_count"
        case rating
        case currentStatus = "current_status"
        case openCloseDate = "open_close_date"
    }
}
