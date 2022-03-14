//
//  OrdersFlow.swift
//  pointee
//
//  Created by Alexander on 21.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa

/**
 Class responsible for creating OrdersFlow
 */
final class OrdersFlow: Flow {
    
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
        guard let step = step as? OrdersStep else { return FlowContributors.none }
        
        switch step {
        case .orders:
            return navigationToOrdersScreen()
        }
    }
    
    deinit {
        print("OrdersFlow deinit")
    }
}

extension OrdersFlow {
    
    private func navigationToOrdersScreen() -> FlowContributors {
        let viewModel = OrdersVM()
        let controller = OrdersVC.instantiate(with: viewModel)

        rootViewController.pushViewController(controller, animated: false)
        return FlowContributors.one(flowContributor: FlowContributor.contribute(withNextPresentable: controller,
                                                                                withNextStepper: viewModel))
    }
}
