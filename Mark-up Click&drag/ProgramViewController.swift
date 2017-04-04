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
    
    
    
    func configureButtons() {
        var i = 0
        for view in customView.subviews as [UIView] {
            if let cpview = view as? ChoosePlaceView {
                    
                i = i + 1
                cpview.placeButton.tag = i
                if let progresses = currentUs.progresses as? Set<Progress> {
                    if progresses.count > 0 {
                        for progress in progresses {
                            if (progress.program == prog) && progress.place == String(i) {
                                print("all")
                                cpview.progressTitle = "\(progress.value)"
                            }
                        }
                    }
                    
                }
                
                cpview.placeButton.addTarget(self, action: #selector(choosePlace(_ :)), for: .touchUpInside)
            }
            
        }
        
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLoad()
            configureButtons()
        
        container = self.parent as! HomeViewController

    
                /*if let img = view1 as? UIImageView {
                    img.highlightedImage = UIImage(named: "speechred.png")
                }*/

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         customView.removeFromSuperview()
    }
    
    func choosePlace(_ sender: UIButton) {
     
        container.place = String(sender.tag)
        container.placeString = sender.titleLabel?.text
        
       for view in customView.subviews {
        if let cpview = view as? ChoosePlaceView {
            cpview.placeButton.setTitleColor(UIColor.white, for: .normal)
        }
        

        for view in customView.subviews {
                if let cpview = view as? ChoosePlaceView {
                    if cpview.placeButton == sender {
                        if Int((cpview.progressTitle)!)! < 5 {
                            container.randomNum = Int((cpview.progressTitle)!)! + 1
                        } else {
                            container.randomNum = 1
                        }
                        cpview.placeButton.setTitleColor(UIColor.red, for: .normal)
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
