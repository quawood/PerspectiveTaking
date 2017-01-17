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

var currentUs:User!
class UserViewController: UIViewController{
    
    // Mark: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    var users = [User]()
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
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let searchResults = try! DatabaseController.getContext().fetch(fetchRequest)
            users = searchResults
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
        
        performSegue(withIdentifier: "toNext", sender: self)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserCollectionViewCell
        print(users.count)
        cell.user = users[indexPath.row]
        cell.layer.cornerRadius = 5
        
        
        // Configure the cell...
        
        
        return cell
    }
}
