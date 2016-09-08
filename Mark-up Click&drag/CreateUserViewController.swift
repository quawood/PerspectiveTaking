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

class CreateUserViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
 
    @IBOutlet weak var nameTextLabel: UITextField!
    @IBOutlet weak var ageTextLabel: UITextField!
    @IBOutlet weak var chooseImage: UIImageView!
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")

        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    @IBAction func chooseImageButton(sender: AnyObject) {
      imagePicker.allowsEditing = false
      imagePicker.sourceType = .PhotoLibrary
        
       presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.LandscapeLeft
        
        
        
        
        

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            chooseImage.contentMode = .ScaleAspectFit
            chooseImage.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func createUser(sender: AnyObject) {
            let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: managedObjectContext)
            let user = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        if nameTextLabel.text != nil && ageTextLabel.text != nil && chooseImage.image != nil {
            user.setValue(nameTextLabel.text, forKey: "name")
            user.setValue(ageTextLabel.text, forKey: "age")
            user.setValue(chooseImage.image, forKey: "profilePic")

            do {
                try managedObjectContext.save()
            }
            catch {
                fatalError("Error in storing to Core Data")
            }


        performSegueWithIdentifier("backToUser", sender: self)
        }
        else {
            let alertConrtoller = UIAlertController(title: "Nothing to save", message: "You have not filled everything out", preferredStyle: .Alert)
            presentViewController(alertConrtoller, animated: true, completion: nil)
        }
        
        
        
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "backToUser" {
            let alertController = UIAlertController(title: "Saved", message:"You have created a new user!",preferredStyle: .Alert)
            segue.destinationViewController.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
   /*override func viewWillDisappear(animated: Bool) {
        let alertController = UIAlertController(title: "All changes will be lost, are you sure?", message: "New User", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler( { (textfield:UITextField) in
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction) -> Void in
        }
        let continueAction = UIAlertAction(title: "Continue", style: .Default) { (action: UIAlertAction) -> Void in
            
        }

        alertController.addAction(cancelAction)
        alertController.addAction(continueAction)

        presentViewController(alertController, animated: true, completion: nil)
    }*/
    


}
