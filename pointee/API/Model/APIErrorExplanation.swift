//
//  APIErrorExplanation.swift
//  pointee
//
//  Created by Alexander on 20.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

/**
   FieldError Model
*/
struct FieldError: Codable, Equatable {
    let field: String
    let error: String
}

/**
   Api Error Explanation Model
*/
struct ApiErrorExplanation: Codable, Equatable {
    let statusCode: Int
    let statusMessage: String
    let reasonPhrase: String
    let fieldErrors: [FieldError]?
}
