//
//  ProgHomeViewController.swift
//  Mark-up Click&drag
//
//  Created by Qualan Woodard on 8/26/16.
//  Copyright © 2016 Pushbox, LLC'. All rights reserved.
//

import UIKit

class ProgHomeViewController: UIViewController {
    
    var program: Int!
    
    @IBOutlet weak var progTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch (program) {
        case 1:
            print("My Community")
        case 2:
            print("My School Day")
        case 3:
            print("School Rules")
        case 4:
            print("PP")
        default:
            break
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
