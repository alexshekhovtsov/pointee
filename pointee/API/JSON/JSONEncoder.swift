//
//  JSONEncoder.swift
//  pointee
//
//  Created by Alexander on 20.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

/**
   Extension of JSONEncoder
*/
extension JSONEncoder {
    
    /// IsoEncoder for Encoding objects with custom dateDecoding Strategy
    static func isoEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .custom() { date, encoder in
            let stringDate = date.toISO8601String()
            var container = encoder.singleValueContainer()
            try container.encode(stringDate)
        }
        return encoder
    }
    
    /// Encode Dates for Sending in Local TimeZone
    static func isoLocalTimeEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .custom() { date, encoder in
            let stringDate = date.toISO8601String(timeZone: .current)
            var container = encoder.singleValueContainer()
            try container.encode(stringDate)
        }
        return encoder
    }
}
