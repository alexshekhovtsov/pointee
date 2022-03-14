//
//  Order.swift
//  pointee
//
//  Created by Alexander on 01.05.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

typealias Orders = [Order]

struct Order: Codable {
    let id: String
    let businessID: String
    let title: String
    let logoURL: String?
    let status: OrderStatus
    let statusDate: Date
    let amount: Float
    let isFavorite: Bool?
    let products: Products
    
    enum CodingKeys: String, CodingKey {
        case id
        case businessID = "business_id"
        case title
        case logoURL = "logo_url"
        case status
        case statusDate = "status_date"
        case amount
        case isFavorite = "is_favorite"
        case products
    }
}

enum OrderStatus: String, Codable, CodingKey {
    case started
    case inProgress = "in_progress"
    case ready
    case canceled
    case successful
    case problem
}

extension OrderStatus {
    var toString: String {
        switch self {
        case .started:
            return R.string.localizable.order_status_started()
        case .inProgress:
            return R.string.localizable.order_status_in_progress()
        case .ready:
            return R.string.localizable.order_status_ready()
        case .canceled:
            return R.string.localizable.order_status_canceled()
        case .successful:
            return R.string.localizable.order_status_successful()
        case .problem:
            return R.string.localizable.order_status_problem()
        }
    }
}
