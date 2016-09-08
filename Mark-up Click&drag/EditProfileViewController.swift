//
//  EditProfileViewController.swift
//  Mark-up Click&drag
//
//  Created by Qualan Woodard on 9/7/16.
//  Copyright © 2016 Pushbox, LLC'. All rights reserved.
//

import UIKit
import CoreData

class EditProfileViewController: UIViewController {
    var scores = currentUs.valueForKey("scores") as! [NSManagedObject]
    


    @IBOutlet weak var tableView: UITableView!
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EditProfileViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ScoreTableViewCell
        
        let score = scores[indexPath.row]
        cell.score = Score(num:(score.valueForKey("num") as! Float),date: (score.valueForKey("date") as! String!),program: (score.valueForKey("program") as! String) )
        
        
        
        // Configure the cell...
        
        
        return cell
    }
    
}