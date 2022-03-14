//
//  AppMainFlow.swift
//  pointee
//
//  Created by Alexander on 20.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import RxFlow
import RxCocoa
import RxSwift

/**
 Class is responsible for coordinating AppMain Flow
 */
final class AppMainFlow: Flow {
    
    /// Root controller of the flow
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController: UITabBarController = {
        let tabController = UITabBarController()
        tabController.tabBar.isTranslucent = false
        tabController.tabBar.backgroundColor = UIConstants.SpaceBlue
        return tabController
    }()
    
    private var disposeBag = DisposeBag()
    
    private func bind() {
        guard let viewControllers = rootViewController.viewControllers, viewControllers.count > 2 else { return }
        CartManager.shared.products
            .asDriver()
            .map { return $0.isEmpty ? nil : $0.map({ $0.count }).reduce(0, +).shortCount() }
            .drive(viewControllers[2].tabBarItem.rx.badgeValue)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Initialize
    
    init() {}
    
    /// Navigate function by Flow protocol
    ///
    /// - Parameter step: Step to next controller
    /// - Returns: Next flow item
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppMainStep else { return .none }
        switch step {
        case .appInitialState:
            return navigationToAppFirstScreen()
        case .filters:
            return navigationToFiltersScreen()
        }
    }
    
    deinit {
        print("AppMainFlow deinit")
    }
}

extension AppMainFlow {
    
    /// Navigation To App First Screen
    ///
    /// - Returns: FlowContributors
    private func navigationToAppFirstScreen() -> FlowContributors {
        let explorerFlow = ExplorerFlow()
        let ordersFlow = OrdersFlow()
        let cartFlow = CartFlow()
        let favoritesFlow = FavoritesFlow()
        let profileFlow = ProfileFlow()

        Flows.whenReady(flow1: explorerFlow,
                        flow2: ordersFlow,
                        flow3: cartFlow,
                        flow4: favoritesFlow,
                        flow5: profileFlow) {
            [unowned self] (root1: UINavigationController,
                            root2: UINavigationController,
                            root3: UINavigationController,
                            root4: UINavigationController,
                            root5: UINavigationController) in
        
            let explorerItem = UITabBarItem(title: R.string.localizable.search(),
                                            image: R.image.pinRound(),
                                            selectedImage: nil)
            let ordersItem = UITabBarItem(title: R.string.localizable.orders(),
                                          image: R.image.list(),
                                          selectedImage: nil)
            let cartItem = UITabBarItem(title: R.string.localizable.cart(),
                                        image: R.image.shoppingCart(),
                                        selectedImage: nil)
            let favoritesItem = UITabBarItem(title: R.string.localizable.favorites(),
                                             image: R.image.favorite_white(),
                                             selectedImage: nil)
            let profileItem = UITabBarItem(title: R.string.localizable.profile(),
                                           image: R.image.user(),
                                           selectedImage: nil)
            
            root1.tabBarItem = explorerItem
            root2.tabBarItem = ordersItem
            root3.tabBarItem = cartItem
            root4.tabBarItem = favoritesItem
            root5.tabBarItem = profileItem

            self.rootViewController.setViewControllers([root1, root2, root3, root4, root5], animated: false)
            self.bind()
        }
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: explorerFlow,
                        withNextStepper: OneStepper(withSingleStep: ExplorerStep.map)),
            .contribute(withNextPresentable: ordersFlow,
                        withNextStepper: OneStepper(withSingleStep: OrdersStep.orders)),
            .contribute(withNextPresentable: cartFlow,
                        withNextStepper: OneStepper(withSingleStep: CartStep.cart)),
            .contribute(withNextPresentable: favoritesFlow,
                        withNextStepper: OneStepper(withSingleStep: FavoritesStep.favorites)),
            .contribute(withNextPresentable: profileFlow,
                        withNextStepper: OneStepper(withSingleStep: ProfileStep.profile))
        ])
    }
    
    private func navigationToFiltersScreen() -> FlowContributors {
        let filtersFlow = FiltersFlow()
        let filtersStepper = OneStepper.init(withSingleStep: FiltersStep.filters)
        Flows.whenReady(flow1: filtersFlow) { [unowned self] (root) in
            root.modalPresentationStyle = .overCurrentContext
            self.rootViewController.present(root, animated: true)
        }
        return .one(flowContributor: .contribute(withNextPresentable: filtersFlow, withNextStepper: filtersStepper))
    }
}

/// AppStepper
final class AppStepper: Stepper {
    let steps = PublishRelay<Step>()
    var initialStep: Step = AppMainStep.appInitialState
}
