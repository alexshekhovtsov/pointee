//
//  ProfileStep.swift
//  pointee
//
//  Created by Alexander on 21.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import RxCocoa
import RxFlow
import RxSwift

enum ProfileStep: Step {
    case profile
    case sign(animated: Bool, needUpdateUser: PublishSubject<Void>)
    case complete
}
