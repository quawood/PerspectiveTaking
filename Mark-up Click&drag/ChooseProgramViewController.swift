//
//  ChooseProgramViewController.swift
//  Mark-up Click&drag
//
//  Created by Qualan Woodard on 11/9/16.
//  Copyright © 2016 Pushbox, LLC'. All rights reserved.
//

import UIKit
var names: [String] = ["My Community", "My School Day", "School Rules 1", "School Rules 2"]
var grandProgram: String!
class ChooseProgramViewController: AudioViewController {
    @IBOutlet var chooseButtons: [UIButton]!
    @IBOutlet weak var backButton: UIButton!

    let hightlightColor: UIColor = UIColor(red:0.76, green:0.29, blue:0.00, alpha:1.0)

    @IBOutlet weak var goNextbutton: UIButton!
    
    /**@IBOutlet weak var programDescription: UILabel!
    var texts: [String] = ["Highlights interactions, expectations and safety precautions with various peers and adults in their community.", "Highlights interactions within an elementary school setting.", "Highlights interactions during structured activities related to middle/high  school in the classroom, group work and physical education.","Highlights interactions during unstructured times related to middle/high school when social rules are most challenging, in the hall, cafeteria and just hanging out."  ]**/
    var programNames: [String] = ["My Community", "My School Day", "School Rules 1", "School Rules 2"]
    var buttonPressed: Int!
    var container: UserViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        /*let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = contentView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(blurEffectView)
        contentView.sendSubview(toBack: blurEffectView)*/
       // grandContainer.layer.cornerRadius = 5
        //grandContainer.layer.borderWidth = 4
       // grandContainer.layer.borderColor = UIColor(red:0, green:0, blue:0, alpha:1.0).cgColor
        for button in chooseButtons {
            button.addTarget(self, action: #selector(highlighta(_ :)), for: .touchUpInside)
            button.style()
        }
        backButton.layer.cornerRadius = 5
        backButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
       /* informationView.layer.cornerRadius = 4
        informationView.layer.borderWidth = 2
        informationView.layer.borderColor = UIColor(red:1.00, green:0.84, blue:0.04, alpha:1.0).cgColor*/
        // Do any additional setup after loading the view.
    }
    @IBAction func unwindToChoose(_ segue: UIStoryboardSegue) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func backSegue(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: self)
    }
    
    @objc func highlighta(_ sender: UIButton) {
        let tagNum = sender.tag - 1
        self.playAudio(fileName: names[tagNum])
        for button in chooseButtons {
            if buttonPressed != nil {
                if button.tag == buttonPressed {
                    button.layer.borderWidth = 0
                }
            } else {
                goNextbutton.backgroundColor = UIColor.clear
                goNextbutton.isUserInteractionEnabled = true
            }
            
        }
       
        //for view in contentView.subviews {
        //    view.loseBorder()
        //}
        //let borderColor = UIColor(red:1.00, green:0.84, blue:0.04, alpha:1.0)
        
        //sender.superview?.highlightBorder(borderColor: borderColor, width: 2)
        sender.borderWidth = 5
        sender.borderColor = UIColor.black
        
        
        
        //programDescription.text = texts[tagNum]
        buttonPressed = sender.tag
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.audioPlayer.stop()
        if segue.identifier == "goToHome" {
            let destinationVC = segue.destination as! HomeViewController
            destinationVC.program = String(buttonPressed)
            
        }
    }

}

/*extension UIView {
    func highlightBorder(borderColor: UIColor, width: CGFloat) {
        let leftBorder = CALayer()
        leftBorder.frame = CGRect(x: 0,y: 0,width: width ,height: bounds.height)
        leftBorder.backgroundColor = borderColor.cgColor
        leftBorder.cornerRadius = 2
        layer.addSublayer(leftBorder)
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: bounds.size.height-width, width: bounds.size.width + width, height: width)
        bottomBorder.backgroundColor = borderColor.cgColor
        bottomBorder.cornerRadius = 2
        layer.addSublayer(bottomBorder)
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: bounds.size.width + width, height: width)
        topBorder.backgroundColor = borderColor.cgColor
        topBorder.cornerRadius = 2
        layer.addSublayer(topBorder)
        
        let rightBorder = CALayer()
        rightBorder.frame = CGRect(x: self.bounds.width - width + width,y: width,width: width,height: bounds.height - (2*width))
        rightBorder.backgroundColor = UIColor(red:0.4, green:0.4, blue:0.4, alpha:1.0).cgColor
        rightBorder.cornerRadius = 2
        layer.addSublayer(rightBorder)
    }
    
    func loseBorder() {
        for layer in self.layer.sublayers! {
            if layer.cornerRadius == 2 {
                layer.removeFromSuperlayer()
            }
            
        }
    }
}*/

