//
//  ChooseProgramViewController.swift
//  Mark-up Click&drag
//
//  Created by Qualan Woodard on 8/26/16.
//  Copyright © 2016 Pushbox, LLC'. All rights reserved.
//

import UIKit
var prog: String!
class HomeViewController: UIViewController{
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    var program: String!
    var place: String!
    var placeString: String!

    @IBOutlet weak var goNextButton: UIButton!
    @IBOutlet weak var programLabel: UILabel!
    
    

    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        programLabel.text = names[Int(program)!-1]
        prog = program
        userNameLabel.text = currentUs.value(forKey: "name") as! String

    }

    override func viewWillDisappear(_ animated: Bool) {
        goNextButton.isHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func goNextAction(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "toQuiz", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuiz"
        {
            var destinationVC = segue.destination as! QuizViewController
            destinationVC.currentProg = program
            destinationVC.currentPlace = place
            destinationVC.placeString = placeString
            
        }
    }
    
}
