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
    var texts: [String] = ["My Community teaches children and young people appropriate social behaviors with various peers and adults within their community.", "My School Day Enhanced CD teaches appropriate interaction and social behaviors within a school setting.", "School Rules! Volume 1 teaches acceptable behaviors during structured activities related to the classroom, group work, and physical education.","School Rules! Volume 2 teaches social interpretation skills during unstructured times where social rules are most challenging"  ]
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
        programInfo.text = texts[sender.tag-1]
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
                    self.layer.borderWidth = 5
                    self.layer.borderColor = UIColor.white.cgColor
                
                
            }
            else if (!newHighlight){
                    self.layer.borderWidth = 3
                    self.layer.borderColor = UIColor.clear.cgColor
                
            }
        }
    }

    }
