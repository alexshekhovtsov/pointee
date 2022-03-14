//
//  APIError.swift
//  pointee
//
//  Created by Alexander on 20.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

enum APIError: Error, Equatable {

    case noData
    case parsingError
    case errorWithStatus(statusCode: Int, explanation: ApiErrorExplanation?)
    
    fileprivate var noDataError: String {
        return R.string.localizable.error_occurred()
    }
    fileprivate var parsingError: String {
        return R.string.localizable.error_occurred()
    }
    fileprivate var genericError: String {
        return R.string.localizable.error_occurred()
    }
    fileprivate var serverError: String {
        return R.string.localizable.error_occurred()
    }
    
    /// Localizable Error
    var localizableError: String {
        switch self {
        case .noData:
            return noDataError
        case .parsingError:
            return parsingError
        case .errorWithStatus(let statusCode, let explanation):
            switch statusCode {
            case 400..<500:
                guard let explanation = explanation else { return genericError }
                guard let fieldErrors = explanation.fieldErrors else { return explanation.statusMessage }
                return fieldErrors.map { $0.error }.joined(separator: "\n")
            case 500:
                return genericError
            default:
                return genericError
            }
        }
    }
}
