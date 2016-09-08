//
//  UserViewController.swift
//  Mark-up Click&drag
//
//  Created by Qualan Woodard on 9/6/16.
//  Copyright © 2016 Pushbox, LLC'. All rights reserved.
//

import UIKit
import CoreData

let reuseIdentifier = "cell"
var managedObjectContext: NSManagedObjectContext!
var currentUs:NSManagedObject!
class UserViewController: UIViewController {
    
    // Mark: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    var users = [NSManagedObject]()
    var cellNum:Int = 1
    

    
    // MARK: - UICollectionViewDataSource
    


    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        /*if users == [] {
            performSegueWithIdentifier("toWelcome", sender: self)
            self.title = "Start by making a new user!"
        }*/
    }
    
    func loadData() {
        let request = NSFetchRequest(entityName: "User")
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        do {
            let results = try managedObjectContext.executeFetchRequest(request)
            users = results as! [NSManagedObject]
            users = users.sort({($0.valueForKey("frequency") as! Float) < ($1.valueForKey("frequency") as! Float)})
            
            collectionView.reloadData()
        }
        catch {
            fatalError("Error in restrieving User items")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }


    func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toWelcome" {
            let vc = segue.destinationViewController
            vc.preferredContentSize = CGSize(width: 500, height: 500)
            let controller = vc.popoverPresentationController
            if controller != nil {
                controller?.delegate = self as? UIPopoverPresentationControllerDelegate
            }
        }
        /*if segue.identifier == "toNext" {
            let controller = segue.destinationViewController as! ChooseViewController
            let row = (sender as! NSIndexPath).row; //we know that sender is an NSIndexPath here.
        }*/
        
    }

}

extension UserViewController : UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return users.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UserCollectionViewCell
        print(users.count)
        let user = users[indexPath.row]
       // cell.user = User(name:users[indexPath.row].valueForKey("name"))
        cell.user = User(name: (users[indexPath.item].valueForKey("name") as! String), profilepic: (users[indexPath.item].valueForKey("profilePic") as! UIImage))
        cell.layer.cornerRadius = 5
        
        
        
        // Configure the cell...
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        cellNum = indexPath.row
        self.performSegueWithIdentifier("toNext", sender: indexPath);
        users[cellNum].setValue((users[cellNum].valueForKey("frequency") as! Float) + 1, forKey: "frequency")
        currentUs = users[cellNum]
        
    }
}