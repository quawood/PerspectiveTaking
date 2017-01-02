//
//  ProgramViewController.swift
//  Mark-up Click&drag
//
//  Created by Qualan Woodard on 10/18/16.
//  Copyright © 2016 Pushbox, LLC'. All rights reserved.
//

import Foundation
import UIKit


class ProgramViewController : UIViewController {
    
    var container: HomeViewController!
    var customView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        let container = self.parent as! HomeViewController
        switch container.program {
            case "1":
                customView = Bundle.main.loadNibNamed("1", owner: self, options: nil)?.first as? UIView
            case "2":
                customView = Bundle.main.loadNibNamed("2", owner: self, options: nil)?.first as? UIView

            
            case "3":
                customView = Bundle.main.loadNibNamed("3", owner: self, options: nil)?.first as? UIView

            
            case "4":
                customView = Bundle.main.loadNibNamed("4", owner: self, options: nil)?.first as? UIView

        default:
                break;
            
        }
        self.view.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":customView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":customView]))
        container.view.backgroundColor = customView.backgroundColor

    }
    override func viewDidLayoutSubviews(){
        super.viewDidLoad()
        var minimumFont: CGFloat = 100
        for view in customView.subviews as [UIView] {
            for view1 in view.subviews as [UIView] {
                if let btn = view1 as? UIButton {
                    btn.addTarget(self, action: #selector(choosePlace(_ :)), for: .touchUpInside)
                }
                if let img = view1 as? UIImageView {
                    img.highlightedImage = UIImage(named: "speechred.png")
                }
            }

        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         customView.removeFromSuperview()
    }
    
    
    
    func choosePlace(_ sender: UIButton) {
        let container = self.parent as! HomeViewController
        print("yah")
     
        container.place = String(sender.tag)
        container.placeString = sender.titleLabel?.text
        for view in customView.subviews as [UIView] {
            for view1 in view.subviews as [UIView] {
                if let btnImg = view1 as? UIImageView {
                    btnImg.isHighlighted = false
                    if btnImg.superview == sender.superview {
                        btnImg.isHighlighted = true
                        
                    }
                    
                    
                }
            }
            
        }
        self.lowlightAll(viewToInspect: customView)
        
        
        container.goNextButton.isHidden = false
        //container.goNextButton.center = CGPoint(x: sender.center.x, y: sender.center.y+80)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension UIViewController {
    func lowlightAll(viewToInspect: UIView) {
        for view in viewToInspect.subviews as [UIView] {
            for view1 in view.subviews as [UIView] {
                if let btn = view1 as? UIButton {
                    btn.isItHighlighted = false
                }
            }
        }
    }
}
