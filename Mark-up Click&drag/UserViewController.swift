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
    

    @IBAction func unwindToUsers(_ segue: UIStoryboardSegue) {
        
    }
    // MARK: - UICollectionViewDataSource
    func checkForFirstOpen() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
        }
        else {
            print("First launch, setting NSUserDefault.")
            performSegue(withIdentifier: "toWelcome", sender: self)
            self.title = "Start by making a new user!"
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
        checkForFirstOpen()

        
    }
    
    
    func loadData() {
        let request: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "User")
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        do {
            let results = try managedObjectContext.fetch(request)
            users = results 
           /* users = users.sorted(by: {($0.value(forKey: "frequency") as! Float) < ($1.value(forKey: "frequency") as! Float)})*/
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
            let vc = segue.destination
            vc.preferredContentSize = CGSize(width: 500, height: 500)
            let controller = vc.popoverPresentationController
            if controller != nil {
                controller?.delegate = self as? UIPopoverPresentationControllerDelegate
            }
        }
        
    }

}

extension UserViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return users.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellNum = indexPath.row
        currentUs = users[cellNum]
        currentUs.setValue(((currentUs.value(forKey: "frequency")as! Int) + 1), forKey: "frequency")
        
        performSegue(withIdentifier: "toNext", sender: self)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserCollectionViewCell
        print(users.count)
        _ = users[indexPath.row]
        // cell.user = User(name:users[indexPath.row].valueForKey("name"))
        cell.user = User(name: (users[indexPath.item].value(forKey: "name") as! String))
        cell.layer.cornerRadius = 5
        
        
        // Configure the cell...
        
        
        return cell
    }
}
