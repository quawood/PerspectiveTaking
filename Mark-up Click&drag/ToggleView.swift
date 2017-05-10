//
//  ToggleView.swift
//  Mark-up Click&drag
//
//  Created by Qualan Woodard on 5/8/17.
//  Copyright © 2017 Pushbox, LLC'. All rights reserved.
//

import Foundation
import UIKit

class ToggleView: UIView {
    

    @IBOutlet weak var onToggleButton: UIButton!
    @IBOutlet weak var offToggleButton: UIButton!
    @IBOutlet weak var highlightMover: UIView!
    
    var toggleBool : Bool?
    {
        didSet {
            var translationFl: CGFloat = onToggleButton.bounds.origin.x - offToggleButton.bounds.origin.x
            UIView.animate(withDuration: 0.1, animations: {
                print(self.toggleBool!)
                if self.toggleBool == true {
                    self.highlightMover.frame.origin.x = self.onToggleButton.frame.origin.x
                } else if self.toggleBool == false {
                    self.highlightMover.frame.origin.x = self.offToggleButton.frame.origin.x
                }
                
            })
            
            //onToggleButton.isUserInteractionEnabled = !onToggleButton.isUserInteractionEnabled
            //offToggleButton.isUserInteractionEnabled = !offToggleButton.isUserInteractionEnabled
        }
    }

    var contentView : UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        self.onToggleButton.setTitle("On", for: .normal)
        self.offToggleButton.setTitle("Off", for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        
        contentView = loadViewFromNib()
        // use bounds not frame or it'll be offset
        contentView!.frame = bounds
        
        // Make the view stretch with containing view
        contentView!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(contentView!)
        highlightMover.layer.cornerRadius = 5 
    }
    
    func loadViewFromNib() -> UIView! {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

