//
//  String+Validation.swift
//  pointee
//
//  Created by Alexander on 22.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

extension String {
    
    var isValidEmailAddress: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        return self.utf8.count >= 6
    }
}
