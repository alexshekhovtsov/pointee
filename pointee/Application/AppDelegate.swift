//
//  AppDelegate.swift
//  pointee
//
//  Created by Alexander on 20.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import Reachability

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let disposeBag = DisposeBag()
    var window: UIWindow?
    var coordinator = FlowCoordinator()
    var authManager = AuthenticationManager.shared
    var appFlow: AppMainFlow!
    var reach: Reachability?
    var banner: TopBanner?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        guard let window = self.window else { return false }
        
        setApplicationAppearance(window)
        
        self.coordinator.rx.willNavigate.subscribe(onNext: { (flow, step) in
            print("will navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)
        
        self.coordinator.rx.didNavigate.subscribe(onNext: { (flow, step) in
            print("did navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)
        
        appFlow = AppMainFlow()
        
        Flows.whenReady(flow1: appFlow) { root in
            window.rootViewController = root
            window.makeKeyAndVisible()
        }
        
        setUpKeyBoard()

        coordinator.coordinate(flow: self.appFlow, with: AppStepper())
        
        GMSServices.provideAPIKey("AIzaSyCJnhp8niDpuJ4hGxPH1eyDrx0Z0N9JH5w")
        GMSPlacesClient.provideAPIKey("AIzaSyCJnhp8niDpuJ4hGxPH1eyDrx0Z0N9JH5w")
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reachabilityChanged(note:)),
                                               name: .reachabilityChanged,
                                               object: reach)
        self.reach = try? Reachability()
        try? reach?.startNotifier()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        reach?.stopNotifier()
        NotificationCenter.default.removeObserver(self,
                                                  name: .reachabilityChanged,
                                                  object: reach)
    }
}

extension AppDelegate {
    
    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if let tabController = self.window?.rootViewController as? UITabBarController {
            if let navigationController = tabController.selectedViewController as? UINavigationController {
                if let controller = navigationController.visibleViewController as? ControllerCanRotate,
                    !controller.changeToDefaultOrientation {
                    return .landscapeRight
                }
            }
        }
        return UIInterfaceOrientationMask.portrait
    }
}

extension AppDelegate {
    
    func setApplicationAppearance(_ window: UIWindow?) {
        if #available(iOS 13.0, *) {
            let buttonAppearance = UIBarButtonItemAppearance()
            buttonAppearance.normal.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.white,
                NSAttributedString.Key.font: UIFont.appFont(atSize: UIConstants.fontSize)
            ]
            buttonAppearance.highlighted.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.white,
                NSAttributedString.Key.font: UIFont.appFont(atSize: UIConstants.fontSize)
            ]
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.backgroundColor = UIConstants.SpaceBlue
            navigationBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.white,
                NSAttributedString.Key.font: UIFont.appFontBold(atSize: UIConstants.fontSize)
            ]
            navigationBarAppearance.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.white,
                NSAttributedString.Key.font: UIFont.appFontBold(atSize: UIConstants.fontSizeBig)
            ]
            navigationBarAppearance.buttonAppearance = buttonAppearance
            navigationBarAppearance.setBackIndicatorImage(R.image.back_button(),
                                                          transitionMaskImage: R.image.back_button())
            UINavigationBar.appearance().tintColor = .white
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.backgroundColor = UIConstants.SpaceBlue
            
            UITabBar.appearance().standardAppearance = tabBarAppearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        } else {
            UINavigationBar.appearance().barTintColor = UIConstants.SpaceBlue
            UINavigationBar.appearance().tintColor = .white
            UINavigationBar.appearance().backIndicatorImage = R.image.back_button()
            UINavigationBar.appearance().backIndicatorTransitionMaskImage = R.image.back_button()
            UINavigationBar.appearance().isTranslucent = false
            
            UINavigationBar.appearance().titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.white,
                NSAttributedString.Key.font: UIFont.appFontBold(atSize: UIConstants.fontSize)
            ]
            
            UINavigationBar.appearance().largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.white,
                NSAttributedString.Key.font: UIFont.appFontBold(atSize: UIConstants.fontSizeBig)
            ]
            
            UIBarButtonItem.appearance().setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor : UIColor.white,
                NSAttributedString.Key.font: UIFont.appFont(atSize: UIConstants.fontSize)
            ], for: .normal)
        }
        UITabBar.appearance().barTintColor = UIConstants.SpaceBlue
        UITabBar.appearance().tintColor = UIConstants.YellowSelected
    }
    
    func setUpKeyBoard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
}

