//
//  JSONDecoder.swift
//  pointee
//
//  Created by Alexander on 20.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

/**
    Extension of JSONDecoder
 */
extension JSONDecoder {
    
    /// IsoDecoder for Decoding objects with custom dateDecoding Strategy
    static func isoDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom() { decoder in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            return dateStr.ISO8601Date() ?? Date()
        }
        return decoder
    }
}
