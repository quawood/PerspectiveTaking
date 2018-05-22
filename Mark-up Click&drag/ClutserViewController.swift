//
//  ClutseringViewController.swift
//  Mark-up Click&drag
//
//  Created by Qualan Woodard on 5/8/18.
//  Copyright © 2018 Pushbox, LLC'. All rights reserved.
//

import Foundation
import UIKit

class ClusterViewController: UIViewController {
    
 
    @IBOutlet weak var testlabel1: UILabel!
    @IBOutlet weak var testlabel2: UILabel!
    @IBOutlet weak var testlabel3: UILabel!
    @IBOutlet weak var testlabel4: UILabel!
    @IBOutlet weak var testlabel5: UILabel!
    @IBOutlet weak var testlabel6: UILabel!
    @IBOutlet weak var testlabel7: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testlabel1.text = "user id: \(currentUs.server_id!)"
        testlabel2.text = "number of questions: \(currentUs.questions?.count)"
        
        let firstQuestion = currentUs.questions?.first(where: {_ in true}) as! Question
        testlabel3.text = "accuracy: \(firstQuestion.accuracy)"
        testlabel4.text = "attempts: \(firstQuestion.attempts)"
        testlabel5.text = "qid: \(firstQuestion.qid)"
        testlabel6.text = "total time: \(firstQuestion.totalt)"
        testlabel7.text = "average time: \(firstQuestion.tperbox)"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
