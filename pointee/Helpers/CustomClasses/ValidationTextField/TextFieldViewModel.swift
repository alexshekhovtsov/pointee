//
//  TextFieldViewModel.swift
//  pointee
//
//  Created by Alexander on 22.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// TextFieldViewable
protocol TextFieldViewable {
    var isRequired: Bool { get }
    var allowsEditing: BehaviorRelay<Bool> { get }
    var showFieldTitle: Bool { get }
    var validateOnEnd: Bool { get }
    var editMode: BehaviorRelay<TextFieldViewModel.EditMode> { get }
    var isSecureTextEntry: Bool { get }
    var fieldBorderWidth: CGFloat { get }
    var fieldBorderColor: CGColor { get }
    var textColor: UIColor { get }
    var titleTextColor: UIColor { get }
    var backgroundColor: UIColor { get }
}

/**
    ViewModel for UITextField
 */
struct TextFieldViewModel {
    
    // MARK: - Properties
    
    /// Text Field Style
    private let style: TextFieldStyle
    /// State of Edit Mode
    let editMode: BehaviorRelay<EditMode>
    /// Is editing allowed
    let allowsEditing = BehaviorRelay(value: false)
    
    // MARK: - Initialize
    /**
    Initialize TextField ViewModel
    - style: TextFieldStyle.
    - editMode: EditMode state
    @return An initialized TextFieldViewModel instance.
    */
    init(_ style: TextFieldStyle,
         editMode: BehaviorRelay<EditMode> = BehaviorRelay<EditMode>(value: .none)) {
        self.style = style
        self.editMode = editMode
        if style.contains(.editable) {
            allowsEditing.accept(true)
        }
    }
    
    /// TextFieldStyle
    struct TextFieldStyle: OptionSet {
        let rawValue: Int
        /// Is editing allowed
        static let editable             = TextFieldStyle(rawValue: 1 << 0)
        /// Is field required
        static let required             = TextFieldStyle(rawValue: 1 << 1)
        /// Field has title
        static let titled               = TextFieldStyle(rawValue: 1 << 2)
        /// Is validation at the end of editing
        static let validateOnEnd        = TextFieldStyle(rawValue: 1 << 3)
        /// Set blue text and grey background
        static let light                = TextFieldStyle(rawValue: 1 << 4)
        /// Set white text and blue background
        static let dark                 = TextFieldStyle(rawValue: 1 << 5)
        /// Set base border width
        static let baseBorderWidth      = TextFieldStyle(rawValue: 1 << 6)
        /// Is entry text hidden
        static let isSecureTextEntry    = TextFieldStyle(rawValue: 1 << 7)
        
        static let signField: TextFieldStyle = []
        static let signFieldPassword: TextFieldStyle = []
        static let profileField: TextFieldStyle = []
    }
    
    /// EditMode
    ///
    /// - active
    /// - unactive
    enum EditMode {
        case active
        case unactive
        case none
        
        init(_ state: Bool) {
            self = state ? .active : .unactive
        }
    }
}

extension TextFieldViewModel: TextFieldViewable {
    
    /// Is Secure Text Entry
    var isSecureTextEntry: Bool {
        return style.contains(.isSecureTextEntry)
    }
    
    /// Is Required
    var isRequired: Bool {
        return style.contains(.required)
    }
    
    /// Show Field Title
    var showFieldTitle: Bool {
        return style.contains(.titled)
    }
    
    /// Validate On End
    var validateOnEnd: Bool {
        return style.contains(.validateOnEnd)
    }
    
    /// Field Border Width
    var fieldBorderWidth: CGFloat {
        if style.contains(.baseBorderWidth) {
            return 2
        }
        return 0
    }
    
    /// Text Color
    var textColor: UIColor {
        if style.contains(.dark) {
            return .white
        }
        return UIConstants.SpaceBlue
    }
    
    /// Title Text Color
    var titleTextColor: UIColor {
        if style.contains(.dark) {
            return .white
        }
        return UIConstants.SpaceBlue
    }
    
    /// Field Border Color
    var fieldBorderColor: CGColor {
        return UIColor.clear.cgColor
    }
    
    var backgroundColor: UIColor {
        if style.contains(.dark) {
            return UIConstants.SpaceBlueLight
        }
        return UIConstants.GreyTextField
    }
}
