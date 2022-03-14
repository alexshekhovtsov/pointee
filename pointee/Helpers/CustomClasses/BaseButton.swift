//
//  BaseButton.swift
//  pointee
//
//  Created by Alexander on 21.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class BaseButton: UIButton {
    
    // MARK: - Properties
    
    var style: ButtonStyle?
    
    var isUppercased = true

    private var shadowLayer: CAShapeLayer!
    private var gradient: CAGradientLayer!
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.15,
                           delay: 0,
                           options: [.beginFromCurrentState, .allowUserInteraction],
                           animations: {
                self.titleLabel?.alpha = self.isHighlighted ? 0.85 : 1
                self.alpha = self.isHighlighted ? 0.85 : 1
                if let shadow = self.layer.sublayers?.first {
                    shadow.opacity = self.isHighlighted ? 0.5 : 1
                    shadow.shadowOffset = CGSize(width: 0.0, height: self.isHighlighted ? 0.5 : 2)
                }
            }, completion: nil)
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            UIView.animate(withDuration: 0.15) {
                self.titleLabel?.alpha = self.isEnabled ? 1 : 0.5
                self.alpha = self.isEnabled ? 1 : 0.5
                if let shadow = self.layer.sublayers?.first {
                    shadow.shadowOffset = CGSize(width: 0.0, height: self.isEnabled ? 2 : 0.5)
                }
            }
        }
    }
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(isUppercased ? title?.uppercased() : title, for: state)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = cornerRadius
        if shadowLayer == nil {
            if let style = style, case .clear = style { return }
            
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            
            shadowLayer.fillColor = backgroundColor?.cgColor
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowRadius = 2

            layer.insertSublayer(shadowLayer, at: 0)
        }
        
        if let style = style, style == .gradient, gradient == nil {
            gradient = CAGradientLayer()
            gradient.colors = [UIConstants.Red.cgColor, UIConstants.YellowSelected.cgColor]
            gradient.locations = [0.0, 1.0]
            gradient.frame = bounds
            gradient.cornerRadius = cornerRadius
            layer.insertSublayer(gradient, at: shadowLayer == nil ? 0 : 1)
        }
    }
}

/**
    Extension for Configuring App Button Styles
 */
extension BaseButton {
    
    func style(_ style: ButtonStyle, isUppercased: Bool = true) {
        self.style = style
        backgroundColor = style.backgroundColor
        titleLabel?.font = style.font
        tintColor = style.tintColor
        setTitleColor(style.tintColor, for: .normal)
        titleLabel?.textAlignment = style.textAlignment
        self.isUppercased = isUppercased
    }
    
    /// ButtonStyle
    ///
    /// - green: Base Button with Green Background Color, White title color, 13pt font size, center and with corner 17
    enum ButtonStyle: Equatable {
        case blue
        case white
        case green
        case red
        case gradient
        case clear(light: Bool)
        
        var backgroundColor: UIColor {
            switch self {
            case .blue:
                return UIConstants.SpaceBlue
            case .white:
                return .white
            case .green:
                return UIConstants.Green
            case .red:
                return UIConstants.Red
            case .clear, .gradient:
                return .clear
            }
        }
        
        var font: UIFont {
            switch self {
            case .blue, .white, .green, .red, .clear, .gradient:
                return .appFontBold(atSize: UIConstants.fontSizeSmall)
            }
        }
        
        var tintColor: UIColor {
            switch self {
            case .blue, .green, .red, .gradient:
                return .white
            case .white:
                return UIConstants.SpaceBlue
            case .clear(let light):
                return light ? .white : UIConstants.SpaceBlue
            }
        }
        
        var textAlignment: NSTextAlignment {
            switch self {
            case .blue, .white, .green, .red, .clear, .gradient:
                return .center
            }
        }
    }
}

extension Reactive where Base: BaseButton {
    
    /// Set Button Style
    var style: Binder<BaseButton.ButtonStyle> {
        return Binder(self.base) { view, value in
            view.style(value)
        }
    }
}
