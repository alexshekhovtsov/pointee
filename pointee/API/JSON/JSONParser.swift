//
//  JSONParser.swift
//  pointee
//
//  Created by Alexander on 20.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

typealias JSONData = Any?

/**
   Extension of JSONParser
*/
final class JSONParser {

    /// Serializes JSON to Data
    static func toData(dictionary: JSONData) -> Data? {
        guard let data = dictionary else { return nil }
        if JSONSerialization.isValidJSONObject(data) {
            let dict = try? JSONSerialization.data(withJSONObject: data, options: [])
            return dict
        } else {
            return nil
        }
    }
}
