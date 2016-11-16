//
//  ChooseProgramViewController.swift
//  Mark-up Click&drag
//
//  Created by Qualan Woodard on 11/9/16.
//  Copyright © 2016 Pushbox, LLC'. All rights reserved.
//

import UIKit
var names: [String] = ["My Community", "My School Day", "School Rules 1", "School Rules 2"]
class ChooseProgramViewController: UIViewController {
    var buttonPressed: UIButton!
    @IBOutlet weak var programInfo: UILabel!
    @IBOutlet weak var goNextButton: UIButton!
    var texts: [String] = ["Learn to take perspective in places around your community with this program! Learn about ", "Go through a school day and learn  ", ""]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func highlighta(_ sender: UIButton) {
        self.lowlightAll(viewToInspect: self.view)
        sender.isItHighlighted = true
        goNextButton.isHidden = false
        programInfo.text = "This program is \(names[sender.tag-1])"
        buttonPressed = sender
        
        
    }
    @IBAction func goToNext(_ sender: Any) {
        performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHome" {
            let dc = segue.destination as! HomeViewController
            dc.program = String(buttonPressed.tag)
            
        }
    }

}

extension UIButton{
    var isItHighlighted: Bool {
        get {
            return self.isItHighlighted
        }
        set(newHighlight) {
            if newHighlight {
                if let checker = self as? UIImageView {
                    checker.isHighlighted = true
                }
                if let checker1 = self as? UIButton {
                    checker1.layer.borderWidth = 3
                    checker1.layer.borderColor = UIColor.red.cgColor
                }
                
                
            }
            else if (!newHighlight){
                if let checker = self as? UIImageView {
                    checker.isHighlighted = false
                }
                if let checker1 = self as? UIButton {
                    checker1.layer.borderWidth = 3
                    checker1.layer.borderColor = UIColor.clear.cgColor
                }
                
            }
        }
    }

    }
