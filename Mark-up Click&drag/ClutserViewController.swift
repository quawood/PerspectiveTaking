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
    
 
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testLabel.text = "\(currentUs.questions?.count) --- \(currentUs.server_id!)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
