//
//  ChoosePlaceView.swift
//  Mark-up Click&drag
//
//  Created by Qualan Woodard on 3/13/17.
//  Copyright © 2017 Pushbox, LLC'. All rights reserved.
//
import UIKit

class ChoosePlaceView: UIView {

    @IBOutlet weak var placeProgressLbl: UILabel?
    @IBOutlet weak var placeButton: UIButton!
    
    
    @IBInspectable var title : String?
        {
        didSet {
            placeButton.setTitle(title, for: .normal)
        }
    }
    
    @IBInspectable var progressTitle : String?
    {
        didSet {
            
            placeProgressLbl?.text = progressTitle
            if progressTitle == "0" {
                placeProgressLbl?.isHidden = true
                placeProgressLbl?.textColor = UIColor.black
            } else if (progressTitle == "5") {
                placeProgressLbl?.isHidden = false
                placeProgressLbl?.textColor = UIColor.red
            }
            
            else {
                placeProgressLbl?.isHidden = false
                placeProgressLbl?.textColor = UIColor.black
            }
        }
    }
    var contentView : UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        contentView = loadViewFromNib()
        if placeProgressLbl?.text == "0" {
            self.progressTitle = "0"
        }
        
        
        // use bounds not frame or it'll be offset
        contentView!.frame = bounds
        
        // Make the view stretch with containing view
        contentView!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(contentView!)
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
