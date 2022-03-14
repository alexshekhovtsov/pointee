//
//  SignFlow.swift
//  pointee
//
//  Created by Alexander on 21.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa

/**
 Class responsible for creating SignFlow
 */
final class SignFlow: Flow {
    
    /// Root controller of the flow
    var root: Presentable {
        return self.rootViewController
    }
    
    private let completeStep: Step
    
    private let needUpdateUser: PublishSubject<Void>
    
    init(completeStep: Step, needUpdateUser: PublishSubject<Void> = PublishSubject<Void>()) {
        self.completeStep = completeStep
        self.needUpdateUser = needUpdateUser
    }
    
    /// Private UINavigationController is a root.
    private lazy var rootViewController: UINavigationController = {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(true, animated: false)
        return navController
    }()
    
    /// Navigate function by Flow protocol
    ///
    /// - Parameter step: Step to next controller
    /// - Returns: Next flow item
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? SignStep else { return FlowContributors.none }
        
        switch step {
        case .signTutorial:
            return navigationToSignTutorialScreen()
        case .dismiss:
            needUpdateUser.onNext(())
            return FlowContributors.end(forwardToParentFlowWithStep: completeStep)
        }
    }
    
    deinit {
        print("SignFlow deinit")
    }
}

extension SignFlow {
    
    private func navigationToSignTutorialScreen() -> FlowContributors {
        let viewModel = SignTutorialVM()
        let controller = SignTutorialVC.instantiate(with: viewModel)

        rootViewController.pushViewController(controller, animated: true)
        return FlowContributors.one(flowContributor: FlowContributor.contribute(withNextPresentable: controller,
                                                                                withNextStepper: viewModel))
    }
}
