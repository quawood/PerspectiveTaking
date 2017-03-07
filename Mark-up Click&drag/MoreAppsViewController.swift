//
//  MoreAppsViewController.swift
//  Mark-up Click&drag
//
//  Created by Qualan Woodard on 3/7/17.
//  Copyright © 2017 Pushbox, LLC'. All rights reserved.
//

import UIKit

class MoreAppsViewController: UIViewController {
    @IBOutlet var apps: [UIButton]!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 500, height: 500)
        for button in apps {
            button.titleLabel?.minimumScaleFactor = 0.5
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.textAlignment = .center
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
