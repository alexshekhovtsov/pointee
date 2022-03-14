//
//  UIViewController+Extension.swift
//  pointee
//
//  Created by Alexander on 21.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIViewController {
    
    /// Present ViewController with FullScreen Mode for iOS 13, where default is automatic
    func presentFullScreen(_ viewControllerToPresent: UIViewController,
                           animated flag: Bool = true,
                           completion: (() -> Void)? = nil) {
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        self.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    func removeBackButtonTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem =
            UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func makeNavigationControllerTrasparent(_ isTransparent: Bool) {
        if isTransparent {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
        } else {
            navigationController?.navigationBar.shadowImage = nil
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        }
    }
    
    func makeNavigationControllerHidden(_ isHidden: Bool, animated: Bool = false) {
        navigationController?.setNavigationBarHidden(isHidden, animated: animated)
    }
    
    func showAlertOkHandler(title: String? = nil,
                            message: String,
                            okTitle: String = R.string.localizable.ok_title(),
                            okHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if #available(iOS 13.0, *) {
            alert.view.tintColor = UIColor.init { trait -> UIColor in
                return trait.userInterfaceStyle == .dark ? UIConstants.YellowSelected : UIConstants.SpaceBlue
            }
        } else {
            alert.view.tintColor = UIConstants.SpaceBlue
        }
        alert.addAction(UIAlertAction(title: okTitle, style: .default, handler: okHandler))
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertYesNoHandlers(title: String? = nil,
                                   message: String,
                                   yesTitle: String,
                                   noTitle: String,
                                   yesHandler: ((UIAlertAction) -> Void)? = nil,
                                   noHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if #available(iOS 13.0, *) {
            alert.view.tintColor = UIColor.init { trait -> UIColor in
                return trait.userInterfaceStyle == .dark ? UIConstants.YellowSelected : UIConstants.SpaceBlue
            }
        } else {
            alert.view.tintColor = UIConstants.SpaceBlue
        }
        alert.addAction(UIAlertAction(title: noTitle, style: .cancel, handler: noHandler))
        alert.addAction(UIAlertAction(title: yesTitle, style: .default, handler: yesHandler))
        present(alert, animated: true, completion: nil)
    }
}

extension Reactive where Base: UIViewController {
    
    /// App Action
    var appAction: Binder<AppAction> {
        return Binder(self.base) { view, value in
            switch value {
            case .error(let message):
                view.showAlertOkHandler(message: message)
            case .info(let title, let message, let okHandler):
                view.showAlertOkHandler(title: title, message: message) { _ in
                    guard let ok = okHandler else { return }
                    ok()
                }
            case .askUser(let title, let message, let yesTitle, let noTitle, let yesHandler, let noHandler):
                let yes = yesTitle ?? R.string.localizable.yes_title()
                let no = noTitle ?? R.string.localizable.cancel()
                
                view.showAlertYesNoHandlers(title: title,
                                            message: message,
                                            yesTitle: yes,
                                            noTitle: no,
                                            yesHandler: { _ in
                    guard let yes = yesHandler else { return }
                    yes()
                }) { _ in
                    guard let no = noHandler else { return }
                    no()
                }
            }
        }
    }
}
