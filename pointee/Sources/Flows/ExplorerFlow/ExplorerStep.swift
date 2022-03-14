//
//  ExplorerStep.swift
//  pointee
//
//  Created by Alexander on 21.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import RxCocoa
import RxFlow
import RxSwift

enum ExplorerStep: Step {
    case map
    case filters
    case sign(animated: Bool, needUpdateUser: PublishSubject<Void>)
    case complete
    case pop
}
