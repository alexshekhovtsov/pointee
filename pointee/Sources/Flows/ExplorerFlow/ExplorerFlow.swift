//
//  ExplorerFlow.swift
//  pointee
//
//  Created by Alexander on 21.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa
import SideMenu

/**
 Class responsible for creating ExplorerFlow
 */
final class ExplorerFlow: Flow {
    
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
        guard let step = step as? ExplorerStep else { return FlowContributors.none }
        
        switch step {
        case .map:
            return navigationToMapScreen()
        case .filters:
            return .one(flowContributor: .forwardToParentFlow(withStep: AppMainStep.filters))
        case .sign(let animated, let needUpdateUser):
            return navigationToSignScreen(animated: animated, needUpdateUser: needUpdateUser)
        case .complete:
            rootViewController.presentedViewController?.dismiss(animated: true, completion: nil)
            return .none
        case .pop:
            rootViewController.popViewController(animated: true)
            return .none
        }
    }
    
    deinit {
        print("ExplorerFlow deinit")
    }
}

extension ExplorerFlow {
    
    private func navigationToMapScreen() -> FlowContributors {
        let viewModel = MapVM()
        let controller = MapVC.instantiate(with: viewModel)

        rootViewController.pushViewController(controller, animated: true)
        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: controller,
                                                                withNextStepper: viewModel))
    }
    
    private func navigationToFiltersScreen() -> FlowContributors {
        let filtersFlow = FiltersFlow()
        let filtersStepper = OneStepper.init(withSingleStep: FiltersStep.filters)
        Flows.whenReady(flow1: filtersFlow) { [unowned self] (root) in
            root.modalPresentationStyle = .overCurrentContext
            self.rootViewController.visibleViewController?.present(root, animated: true)
        }
        return .one(flowContributor: .contribute(withNextPresentable: filtersFlow, withNextStepper: filtersStepper))
    }
    
    private func navigationToSignScreen(animated: Bool, needUpdateUser: PublishSubject<Void>) -> FlowContributors {
        let stepper = OneStepper.init(withSingleStep: SignStep.signTutorial)
        let flow = SignFlow(completeStep: ExplorerStep.complete, needUpdateUser: needUpdateUser)
        Flows.whenReady(flow1: flow) { [unowned self] root in
            self.rootViewController.presentFullScreen(root, animated: animated)
        }
        return .one(flowContributor: .contribute(withNextPresentable: flow, withNextStepper: stepper))
    }
}

/**
    Custom NavigationController for better animation
 */
final class CustomNavigationController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        if viewController == self.viewControllers.first {
            self.setNavigationBarHidden(false, animated: animated)
        }
    }
}
