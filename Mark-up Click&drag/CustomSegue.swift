//
//  Custom.swift
//  Mark-up Click&drag
//
//  Created by Qualan Woodard on 12/26/16.
//  Copyright © 2016 Pushbox, LLC'. All rights reserved.
//

import UIKit

class CustomSegue: UIStoryboardSegue {
    override func perform() {
        let source = self.source as UIViewController
        let destination = self.destination as UIViewController
        let window = UIApplication.shared.keyWindow!
       // destination.view.frame.size = CGSize(width: 0, height: 0)
        destination.view.alpha = 0.0
        window.insertSubview(destination.view, belowSubview: source.view)
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            destination.view.alpha = 1.0
            source.view.alpha = 0
            //destination.view.frame.size = CGSize(width: 500, height: 500)
        }) { (finished) -> Void in
            source.view.alpha = 1.0
            source.present(destination, animated: false, completion: nil)
        }
    }
}
