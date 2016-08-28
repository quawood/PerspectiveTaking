//
//  CustomView.swift
//  Mark-up Click&drag
//
//  Created by Qualan Woodard on 8/23/16.
//  Copyright © 2016 Pushbox, LLC'. All rights reserved.
//

import UIKit
@IBDesignable
class CustomView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var zPosition: CGFloat? {
        didSet {
            layer.zPosition = zPosition!
        }
    }
    
    @IBInspectable var hasDropShadow: Bool = false {
        didSet {
            if hasDropShadow == true {
                layer.shadowColor = UIColor.black.cgColor
                layer.shadowOffset = CGSize(width:0,height: 1.0)
                layer.masksToBounds = false
                layer.shadowRadius = 1.0
                layer.shadowOpacity = 1
            }
        }
    }
    


}
