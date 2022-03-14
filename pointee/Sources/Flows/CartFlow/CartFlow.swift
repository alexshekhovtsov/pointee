//
//  CartFlow.swift
//  pointee
//
//  Created by Alexander on 26.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa

/**
 Class responsible for creating CartFlow
 */
final class CartFlow: Flow {
    
    /// Root controller of the flow
    var root: Presentable {
        return self.rootViewController
    }
    
    /// Private UINavigationController is a root.
    private lazy var rootViewController: UINavigationController = {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(false, animated: false)
        return navController
    }()
    
    /// Navigate function by Flow protocol
    ///
    /// - Parameter step: Step to next controller
    /// - Returns: Next flow item
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? CartStep else { return FlowContributors.none }
        
        switch step {
        case .cart:
            return navigationToCartScreen()
        case .complete:
            rootViewController.presentedViewController?.dismiss(animated: true, completion: nil)
            return .none
        }
    }
    
    deinit {
        print("CartFlow deinit")
    }
}

extension CartFlow {
    
    private func navigationToCartScreen() -> FlowContributors {
        let viewModel = CartVM(root: rootViewController)
        let controller = CartVC.instantiate(with: viewModel)

        rootViewController.pushViewController(controller, animated: false)
        return FlowContributors.one(flowContributor: FlowContributor.contribute(withNextPresentable: controller,
                                                                                withNextStepper: viewModel))
    }
}
