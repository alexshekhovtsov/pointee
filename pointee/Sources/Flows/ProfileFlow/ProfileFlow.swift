//
//  ProfileFlow.swift
//  pointee
//
//  Created by Alexander on 21.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa

/**
 Class responsible for creating ProfileFlow
 */
final class ProfileFlow: Flow {
    
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
        guard let step = step as? ProfileStep else { return FlowContributors.none }
        
        switch step {
        case .profile:
            return navigationToProfileScreen()
        case .sign(let animated, let needUpdateUser):
            return navigationToSignScreen(animated: animated, needUpdateUser: needUpdateUser)
        case .complete:
            rootViewController.presentedViewController?.dismiss(animated: true, completion: nil)
            return .none
        }
    }
    
    deinit {
        print("ProfileFlow deinit")
    }
}

extension ProfileFlow {
    
    private func navigationToProfileScreen() -> FlowContributors {
        let viewModel = ProfileVM()
        let controller = ProfileVC.instantiate(with: viewModel)

        rootViewController.pushViewController(controller, animated: false)
        return FlowContributors.one(flowContributor: FlowContributor.contribute(withNextPresentable: controller,
                                                                                withNextStepper: viewModel))
    }
    
    private func navigationToSignScreen(animated: Bool, needUpdateUser: PublishSubject<Void>) -> FlowContributors {
        let stepper = OneStepper.init(withSingleStep: SignStep.signTutorial)
        let flow = SignFlow(completeStep: ProfileStep.complete, needUpdateUser: needUpdateUser)
        Flows.whenReady(flow1: flow) { [unowned self] root in
            self.rootViewController.presentFullScreen(root, animated: animated)
        }
        return .one(flowContributor: .contribute(withNextPresentable: flow, withNextStepper: stepper))
    }
}
