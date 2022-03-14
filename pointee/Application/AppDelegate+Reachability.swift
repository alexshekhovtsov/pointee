//
//  AppDelegate+Reachability.swift
//  pointee
//
//  Created by Alexander on 20.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import UIKit
import Reachability

extension AppDelegate {
    
    @objc func reachabilityChanged(note: Notification) {
        
        guard let reachability = note.object as? Reachability else {
            return
        }
        
        switch reachability.connection {
        case .wifi, .cellular:
            self.showNoInternetBanner(isInternet: false)
        case .none, .unavailable:
            self.showNoInternetBanner(isInternet: true)            
        }
    }
    
    func showNoInternetBanner(isInternet: Bool) {
        if isInternet {
            if banner == nil {
                banner = TopBanner(title: R.string.localizable.check_internet())
                banner?.show()
            }
        } else {
            banner?.dismiss()
            banner = nil
        }
    }
}

class TopBanner: UIView {
    
    var bannerWindow: UIWindow? {
        for window in UIApplication.shared.windows.reversed() {
            if window.windowLevel == UIWindow.Level.normal && window.isKeyWindow && window.frame != CGRect.zero {
                return window
            }
        }
        return nil
    }
    
    private var hiddenNow = true
    
    private let statusBarHeight = UIApplication.shared.statusBarFrame.height
    private let minimalViewHeight: CGFloat = 80
    
    private var didTap: (() -> Void)? = nil
    
    func show() {
        if let window = bannerWindow, hiddenNow {
            alpha = 0
            window.addSubview(self)
            anchor(top: window.topAnchor,
                        leading: window.leadingAnchor,
                        bottom: nil,
                        trailing: window.trailingAnchor)
            heightAnchor.constraint(greaterThanOrEqualToConstant: statusBarHeight + minimalViewHeight).isActive = true
            hiddenNow = false
            UIView.animate(withDuration: UIConstants.animationTime) {
                self.alpha = 1
            }
        }
    }
    
    init(title: String, didTap: (() -> Void)? = nil) {
        super.init(frame: .zero)
        self.didTap = didTap
        
        let title = UILabel(text: title,
                            font: .appFontBold(atSize: UIConstants.fontSize),
                            textColor: .white,
                            textAlignment: .center,
                            numberOfLines: 0)
        
        self.addSubview(title)
        title.anchor(top: self.topAnchor,
                     leading: self.leadingAnchor,
                     bottom: nil,
                     trailing: self.trailingAnchor,
                     padding: UIEdgeInsets(top: statusBarHeight,
                                           left: UIConstants.marginS,
                                           bottom: 0,
                                           right: UIConstants.marginS))

        let button = UIButton()
        button.addTarget(self, action: #selector(defaultTap), for: .touchUpInside)
        self.addSubview(button)
        button.fillSuperview()
    }
    
    @objc private func defaultTap() {
        if let tap = didTap {
            tap()
        }
        dismiss()
    }
    
    func dismiss() {
        UIView.animate(withDuration: UIConstants.animationTime, animations: {
            self.alpha = 0
        }) { _ in
            self.isHidden = true
            self.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let gradient = CAGradientLayer()
        gradient.colors = [UIConstants.Red.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.2, 1]
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
    }
}
