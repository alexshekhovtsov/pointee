//
//  FiltersFlow.swift
//  pointee
//
//  Created by Alexander on 04.05.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa
import SideMenu

/**
 Class responsible for creating FiltersFlow
 */
final class FiltersFlow: Flow {
    
    /// Root controller of the flow
    var root: Presentable {
        return self.rootViewController
    }
    
    /// Filters ViewModel
    private lazy var filtersVM: FiltersVM = {
        return FiltersVM()
    }()
    /// Filters Controller
    private lazy var filtersVC: FiltersVC = {
        return FiltersVC.instantiate(with: filtersVM)
    }()
    
    /// Private UISideMenuNavigationController is a root.
    private lazy var rootViewController: SideMenuNavigationController = {
        let filters = SideMenuNavigationController(rootViewController: filtersVC)
        filters.isNavigationBarHidden = false
        filters.pushStyle = .subMenu
        filters.leftSide = true
        filters.menuWidth = UIScreen.main.bounds.width / 1.123
        filters.presentationStyle = .menuSlideIn
        filters.presentationStyle.menuOnTop = true
        filters.presentationStyle.onTopShadowOpacity = 0.8
        filters.presentationStyle.presentingEndAlpha = 0.5
        filters.statusBarEndAlpha = 0
        filters.animationOptions = .curveEaseIn
        SideMenuManager.default.leftMenuNavigationController = filters
        return filters
    }()
    
    /// Navigate function by Flow protocol
    ///
    /// - Parameter step: Step to next controller
    /// - Returns: Next flow item
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? FiltersStep else { return FlowContributors.none }
        
        switch step {
        case .filters:
            return navigationToFiltersScreen()
        case .tagsList(let selectedTags, let allTags):
            return navigationToTagsListScreen(selectedTags: selectedTags, allTags: allTags)
        case .dismiss:
            rootViewController.dismiss(animated: true)
            return .none
        }
    }
    
    deinit {
        print("FiltersFlow deinit")
    }
}

extension FiltersFlow {
    
    /// Configure Filters
    ///
    /// - Returns: FlowContributors
    private func navigationToFiltersScreen() -> FlowContributors {
        return .one(flowContributor: .contribute(withNextPresentable: rootViewController, withNextStepper: filtersVM))
    }
    
    /// Configure Filters
    ///
    /// - Returns: FlowContributors
    private func navigationToTagsListScreen(selectedTags: BehaviorRelay<[String]>,
                                            allTags: [String]) -> FlowContributors {
        let viewModel = TagListVM(selectedTags: selectedTags, allTags: allTags)
        let controller = TagListVC.instantiate(with: viewModel)

        rootViewController.pushViewController(controller, animated: true)
        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: controller,
                                                                withNextStepper: viewModel))
    }
}
