//
//  Product.swift
//  pointee
//
//  Created by Alexander on 25.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

typealias Products = [Product]

struct Product: Codable {
    let barcode: String
    let vendorCode: String
    let sellerID: String
    let title: String
    let imageURL: String
    let manufacturer: String
    let price: Float
    let description: String?
    let type: ProductType
    let status: ProductStatus?
    
    enum CodingKeys: String, CodingKey {
        case barcode
        case vendorCode = "vendor_code"
        case sellerID = "seller_id"
        case title
        case imageURL = "image_url"
        case manufacturer
        case price
        case description
        case type
        case status
    }
}

enum ProductType: String, Codable, CodingKey {
    case goods
    case dishes
}

enum ProductStatus: String, Codable, CodingKey {
    case enabled
    case temporaryDisabled = "temporary_disabled"
    case hidden
}
