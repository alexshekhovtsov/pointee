//
//  FiltersStep.swift
//  pointee
//
//  Created by Alexander on 04.05.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import RxCocoa
import RxFlow
import RxSwift

enum FiltersStep: Step {
    case filters
    case tagsList(selectedTags: BehaviorRelay<[String]>, allTags: [String])
    case dismiss
}
