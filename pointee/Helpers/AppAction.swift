//
//  AppAction.swift
//  pointee
//
//  Created by Alexander on 07.05.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

/// AppUIAction
///
/// - error: Error
/// - info: Info
/// - askUser: Confirm user action
enum AppAction {
    case error(message: String)
    case info(title: String?, message: String, okHandler: (() -> Void)?)
    case askUser(title: String?,
                 message: String,
                 yesTitle: String?,
                 noTitle: String?,
                 yesHandler: (() -> Void)?,
                 noHandler: (() -> Void)?)
}
