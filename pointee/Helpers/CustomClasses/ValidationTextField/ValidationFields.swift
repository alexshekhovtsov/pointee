//
//  ValidationFields.swift
//  pointee
//
//  Created by Alexander on 22.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

/// Password TextField Validation View
final class PasswordValidationField: ValidationTextField {
    
    /// Check if Content in Field is Valid
    ///
    /// - Parameter value: String
    /// - Returns: Bool
    override func isValidContent(_ value: String?) -> Bool {
        if let value = value {
            if value.isEmpty { return !viewModel.isRequired }
            return value.isValidPassword
        }
        return false
    }
}

/// Email TextField Validation View
final class EmailValidationField: ValidationTextField {
    
    /// Check if Content in Field is Valid
    ///
    /// - Parameter value: String
    /// - Returns: Bool
    override func isValidContent(_ value: String?) -> Bool {
        if let value = value {
            if value.isEmpty { return !viewModel.isRequired }
            return value.isValidEmailAddress
        }
        return false
    }
}

/// Text TextField Validation View
final class TextValidationField: ValidationTextField {
    
    /// Check if Content in Field is Valid
    ///
    /// - Parameter value: String
    /// - Returns: Bool
    override func isValidContent(_ value: String?) -> Bool {
        if let value = value {
            if value.isEmpty { return !viewModel.isRequired }
            return value.count >= 2
        }
        return false
    }
}
