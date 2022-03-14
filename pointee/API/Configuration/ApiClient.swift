//
//  ApiClient.swift
//  pointee
//
//  Created by Alexander on 20.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

/// Result
enum Result <T: Any> {
    case success(T)
    case error(APIError)
}
/// ResultHandler of Request
typealias ResultHandler<T: Any> = (Result<T>) -> Void
