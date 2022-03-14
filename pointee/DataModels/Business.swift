//
//  Business.swift
//  pointee
//
//  Created by Alexander on 24.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

typealias WorkingWeek = [WorkingDay]

extension WorkingWeek {
    var nextCloseTime: Date? {
        if let time = self.first(where: { $0.day >= Date().weekday?.rawValue ?? 0 && $0.closeTime != nil }) {
            return time.closeTime
        }
        if let time = self.first(where: { $0.day < Date().weekday?.rawValue ?? 0 && $0.closeTime != nil }) {
            return time.closeTime
        }
        return nil
    }
}

struct Business: Codable {
    let id: String
    let latitude: Double
    let longitude: Double
    let title: String
    let logoURL: String
    let previewURL: String?
    let imagesURLs: [String]?
    let type: BusinessType
    let rating: Float
    let reviewsCount: Int
    let contactInfo: ContactInfo
    let tags: [String]?
    let schedule: WorkingWeek
    let lastOrderInterval: Float
    let orderCancelInterval: Float?
    let currentStatus: BusinessStatus
    
    enum CodingKeys: String, CodingKey {
        case id
        case latitude
        case longitude
        case title
        case logoURL = "logo_url"
        case previewURL = "preview_url"
        case imagesURLs = "images_urls"
        case type
        case rating
        case reviewsCount = "reviews_count"
        case contactInfo = "contact_info"
        case tags
        case schedule
        case lastOrderInterval = "last_order_interval"
        case orderCancelInterval = "order_cancel_interval"
        case currentStatus = "current_status"
    }
    
    func makeLocation() -> BusinessLocation {
        return BusinessLocation(id: id,
                                latitude: latitude, 
                                longitude: longitude, 
                                title: title, 
                                logoURL: logoURL, 
                                previewURL: previewURL, 
                                reviewsCount: reviewsCount, 
                                rating: rating, 
                                currentStatus: currentStatus, 
                                openCloseDate: schedule.nextCloseTime)
    }
}

struct ContactInfo: Codable {
    let address: String
    let phone: String?
    let email: String?
    let website: String?
}
