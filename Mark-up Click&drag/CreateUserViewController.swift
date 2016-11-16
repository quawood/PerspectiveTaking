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
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateUserViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }


    
   func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
            else {
                
            }
        }
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
            let entity = NSEntityDescription.entity(forEntityName: "User", in: managedObjectContext)
            let user = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
            
            let components = calendar.dateComponents([.month,.day,.year], from: date)
            user.setValue(nameTextLabel.text, forKey: "name")
        
            user.setValue("\(components.month!)/\(components.day!)/\(components.year!)", forKey: "dateCreated")
            user.setValue([0] as [Float], forKey: "scores1")
            user.setValue([0] as [Float], forKey: "scores2")
            user.setValue([0] as [Float], forKey: "scores3")
            user.setValue([0] as [Float], forKey: "scores4")
            do {
                try managedObjectContext.save()
            } catch {
                let saveError = error as NSError
                print(saveError)
            }


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
