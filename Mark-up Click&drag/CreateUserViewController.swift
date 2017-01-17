//
//  CreateUserViewController.swift
//  Mark-up Click&drag
//
//  Created by Qualan Woodard on 9/6/16.
//  Copyright © 2016 Pushbox, LLC'. All rights reserved.
//

import UIKit
import CoreData
import CoreGraphics
import QuartzCore

class CreateUserViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate{
    
    
    let date = Date()
    let calendar = NSCalendar.current
    @IBOutlet weak var nameTextLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.nameTextLabel.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateUserViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }


    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
   

    
    @IBAction func cancelCreatUser(_ sender: AnyObject) {
        let alertConrtoller = UIAlertController(title: "Go back?", message: "Do you want to go back?", preferredStyle: .alert)
        alertConrtoller.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            alertConrtoller.dismiss(animated: true, completion: nil)
        }))
        alertConrtoller.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.performSegue(withIdentifier: "backToUser", sender: self)
        }))
        present(alertConrtoller, animated: true, completion: nil)
    }
    @IBAction func createUser(sender: AnyObject) {

        if (nameTextLabel.text != ""){
            let components = calendar.dateComponents([.month,.day,.year], from: date)
            let user: User = NSEntityDescription.insertNewObject(forEntityName: "User", into: DatabaseController.getContext()) as! User
            
            user.name = nameTextLabel.text
            user.dateCreated = "\(components.month!)/\(components.day!)/\(components.year!)"
            
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
                user.addToScores(score1)
            }
            
            user.addToScores(score1)
            
            DatabaseController.saveContext()


        self.performSegue(withIdentifier: "backToUser", sender: self)
        
        }
        else {
            let alertConrtoller = UIAlertController(title: "Nothing to save", message: "You have not filled everything out", preferredStyle: .alert)
           alertConrtoller.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                alertConrtoller.dismiss(animated: true, completion: nil)
            }))
            present(alertConrtoller, animated: true, completion: nil)
        }
        
        
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToUser" {
            let vc = segue.destination as! UserViewController
            vc.loadData()
        }
    }
    

}
