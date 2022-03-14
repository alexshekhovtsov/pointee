//
//  UIView+Style.swift
//  pointee
//
//  Created by Alexander on 21.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import UIKit

let kShadowLayerNameKey = "kShadowLayerNameKey"

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            if let newColor = newValue {
                layer.borderColor = newColor.cgColor
            } else {
                layer.borderColor = nil
            }
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        set {
            if let newColor = newValue {
                var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
                if newColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
                    let c = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
                    layer.shadowColor = c.cgColor
                    layer.shadowOpacity = Float(alpha)
                }
            } else {
                layer.shadowColor = nil
            }
        }
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        set {
            layer.shadowOffset = newValue
            layer.masksToBounds = false
        }
        get {
            return layer.shadowOffset
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }
}

extension UIView {
    
    /// In layoutSubviews()
    func addShadow(offset: CGSize = CGSize(width: 0.0, height: 2.0),
                   opacity: Float = 0.3,
                   shadowRadius: CGFloat = 4,
                   corners: UIRectCorner = [.allCorners]) {
        
        layoutIfNeeded()
        
        if let shadow = layer.sublayers?.first(where: { $0.name == kShadowLayerNameKey }) {
            if let shadow = shadow as? CAShapeLayer {
                shadow.path = UIBezierPath(roundedRect: bounds,
                                           byRoundingCorners: corners,
                                           cornerRadii: CGSize(width: layer.cornerRadius,
                                                               height: layer.cornerRadius)).cgPath
                shadow.shadowPath = shadow.path
            }
        } else {
            let shadowLayer = CAShapeLayer()
            shadowLayer.name = kShadowLayerNameKey
            shadowLayer.path = UIBezierPath(roundedRect: bounds,
                                            byRoundingCorners: corners,
                                            cornerRadii: CGSize(width: layer.cornerRadius,
                                                                height: layer.cornerRadius)).cgPath
            shadowLayer.fillColor = backgroundColor?.cgColor
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = offset
            shadowLayer.shadowOpacity = opacity
            shadowLayer.shadowRadius = shadowRadius
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
    func removeShadow() {
        layer.sublayers?.removeAll(where: { $0.name == kShadowLayerNameKey })
    }
}
