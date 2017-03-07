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

        for view in customView.subviews {
            for view1 in view.subviews as [UIView] {
                if let btn = view1 as? UIButton {
                    btn.addTarget(self, action: #selector(choosePlace(_ :)), for: .touchUpInside)
                }
                
                    
                }
        }
        
                /*if let img = view1 as? UIImageView {
                    img.highlightedImage = UIImage(named: "speechred.png")
                }*/

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         customView.removeFromSuperview()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        for view in self.view.subviews {
            if view.frame.contains((touch?.location(in: self.view))!) {
                break
            }
            
            for view in customView.subviews {
                if let view1 = view as? UIView{
                    view1.layer.borderColor = UIColor.white.cgColor
                    view1.layer.borderWidth = 0
                    container.goNextButton.isHidden = true 
                    
                    
                }
                
                }

        }
    }
    
    func choosePlace(_ sender: UIButton) {
        container = self.parent as! HomeViewController
        print("yah")
     
        container.place = String(sender.tag)
        container.placeString = sender.titleLabel?.text
       for view in customView.subviews {
                            if let view1 = view as? UIView{
                    view1.layer.borderColor = UIColor.white.cgColor
                    view1.layer.borderWidth = 0
                    
                    
         
            }
        for view1 in customView.subviews {
            for view2 in view1.subviews as [UIView] {
                if let btn = view2 as? UIButton {
                    if btn == sender {
                        view1.layer.borderColor = UIColor(red:1.00, green:0.86, blue:0.52, alpha:1.0).cgColor
                        view1.layer.borderWidth = 4
                    }
                    
                }
            }
            
        }
            
        }

        
        
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
                view1.layer.borderColor = UIColor.white.cgColor
                view1.layer.borderWidth = 0
            }
        }
    }
}
