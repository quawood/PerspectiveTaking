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
class UserViewController: AudioViewController{
    
    // Mark: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    let date = Date()
    let calendar = NSCalendar.current
    var users = [User]()
    var cellNum:Int = 1
    var program: String!

    @IBAction func unwindToUsers(_ segue: UIStoryboardSegue) {
        
    }
    // MARK: - UICollectionViewDataSource
    func checkForFirstOpen() {
      /*  let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
        }
        else {
            print("First launch, setting NSUserDefault.")
            performSegue(withIdentifier: "toWelcome", sender: self)
            self.title = "Start by making a new user!"
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            
        }*/
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
        checkForFirstOpen()

        
    }
    @IBAction func newUserBtn(_ sender: Any) {
        self.audioPlayer.stop()
        newUser()
    }
    
    func newUser() {
        let alert = UIAlertController(title: "Create User", message: "Enter a User name", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "enter name here"
            textField.textAlignment = .center
            textField.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
            
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields?[0] // Force unwrapping because we know it exists.
            textField?.autocapitalizationType = UITextAutocapitalizationType.words
            if textField?.text != ""{
                
                let components = self.calendar.dateComponents([.month,.day,.year], from: self.date)
                let user: User = NSEntityDescription.insertNewObject(forEntityName: "User", into: DatabaseController.getContext()) as! User
                
                user.name = textField?.text
                user.server_id = self.randomString(length: 20)
                user.dateCreated = "\(components.month!)/\(components.day!)/\(components.year!)"
                user.isAudioEnabled = true
                let score1: Score = NSEntityDescription.insertNewObject(forEntityName: "Score", into: DatabaseController.getContext()) as! Score
                score1.date = ""
                score1.value = 0
                score1.place = ""
                score1.program = ""
                for i in 1...4 {
                    let score1: Score = NSEntityDescription.insertNewObject(forEntityName: "Score", into: DatabaseController.getContext()) as! Score
                    score1.date = ""
                    score1.value = 0
                    score1.place = ""
                    score1.program = String(i)
                    score1.attempt = Int16(0)
                    user.addToScores(score1)
                }
                for i in 1...110 {
                    let question: Question = NSEntityDescription.insertNewObject(forEntityName: "Question", into: DatabaseController.getContext()) as! Question
                    question.qid = "\(i)"
                    question.accuracy = 2
                    user.addToQuestions(question)
                }
                
                DatabaseController.saveContext()
                alert?.dismiss(animated: true, completion: nil)
                self.loadData()
                // First figure out how many sections there are
                let lastSectionIndex = self.collectionView!.numberOfSections - 1
                
                // Then grab the number of rows in the last section
                let lastRowIndex = self.collectionView!.numberOfItems(inSection: lastSectionIndex) - 1
                
                // Now just construct the index path
                let pathToLastRow = NSIndexPath(row: lastRowIndex, section: lastSectionIndex)
                
                // Make the last row visible
                self.collectionView.scrollToItem(at: pathToLastRow as IndexPath, at: UICollectionViewScrollPosition.left, animated: true)

            }else {
                textField?.text = "You need a user name or that user name is already taken"
                textField?.textColor = UIColor.red
                textField?.reloadInputViews()
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak alert] (_) in
            alert?.dismiss(animated: true, completion: nil)
        }))
        
        // 4. Present the alert.
        alert.actions[0].isEnabled = false
        self.present(alert, animated: true, completion: nil)
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    @objc func textChanged(_ sender: Any) {
        var isNameOriginal = true

        let tf = sender as! UITextField
        for user in self.users {
            if tf.text == user.name {
                isNameOriginal = false
            }
        }
        var resp : UIResponder! = tf
        while !(resp is UIAlertController) { resp = resp.next }
        let alert = resp as! UIAlertController
        alert.actions[0].isEnabled = (tf.text != "")&&(isNameOriginal == true)
    }
    
    func loadData() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let searchResults = try! DatabaseController.getContext().fetch(fetchRequest)
            users = searchResults
            collectionView.reloadData()
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
        } else if segue.identifier == "goToHome" {
                    let dc = segue.destination as! HomeViewController
                    dc.program = program

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
        if currentUs.server_id == "replace" {
            currentUs.server_id = randomString(length: 20)
        }
        performSegue(withIdentifier: "toNext", sender: self)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserCollectionViewCell
        cell.user = users[indexPath.row]
        cell.layer.cornerRadius = 5
        
        
        // Configure the cell...
        
        
        return cell
    }
}

