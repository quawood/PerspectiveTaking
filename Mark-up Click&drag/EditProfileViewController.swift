//
//  EditProfileViewController.swift
//  Mark-up Click&drag
//
//  Created by Qualan Woodard on 9/7/16.
//  Copyright © 2016 Pushbox, LLC'. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class EditProfileViewController: UIViewController,UINavigationControllerDelegate, UITextFieldDelegate {

    


    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var toggleAudioView: ToggleView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var editSaveButton: UIButton!
    @IBOutlet weak var saveEditButton: UIButton!
    @IBOutlet weak var canceEditingButton: UIButton!
    //@IBOutlet weak var goBackHomeButton: UIButton!
    @IBOutlet weak var realView: UIView!
    
     
    func loadData() {
        nameText.text = currentUs.name
        dateCreatedLabel.text = "Created: \(currentUs.dateCreated!)"
    }
    
    func saveData() {
        currentUs.name = nameText.text
    }
    
    func stlyeScene() {
        for button in buttons as [UIButton]{
            button.style()
        }
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if !realView.frame.contains(touch.location(in: self.view)) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    


    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        toggleAudioView.onToggleButton.addTarget(self, action: #selector(toggleAudio(_ :)),for: .touchUpInside)
        toggleAudioView.offToggleButton.addTarget(self, action: #selector(toggleAudio(_ :)), for: .touchUpInside)

        loadData()
        toggleAudioView.toggleBool = currentUs.isAudioEnabled
        self.nameText.delegate = self
        
        //chooseImage.layer.cornerRadius = 155 ;
        // Do any additional setup after loading the view.
        containerView.layer.cornerRadius = 15
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditProfileViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        stlyeScene()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func enableEditing() {
        saveEditButton.isHidden = false
        editSaveButton.isHidden = true
        saveEditButton.isHidden = false
        canceEditingButton.isHidden = false
        //goBackHomeButton.isHidden = true
        nameText.isUserInteractionEnabled = true

    }
    
    func disableEditing() {

        editSaveButton.isHidden = false
        saveEditButton.isHidden = true
       // goBackHomeButton.isHidden = false
        canceEditingButton.isHidden = true
        nameText.isUserInteractionEnabled = false
        
        
    }

    func toggleAudio(_ sender: UIButton) {
        currentUs.isAudioEnabled = !currentUs.isAudioEnabled
        
        DatabaseController.saveContext()
        toggleAudioView.toggleBool = currentUs.isAudioEnabled
    }
    
    
    @IBAction func deleteStudent(_ sender: AnyObject) {
        let alertConrtoller = UIAlertController(title: "Delete Student?", message: "You will not be able to undo deletion", preferredStyle: .alert)
        alertConrtoller.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            alertConrtoller.dismiss(animated: true, completion: nil)
        }))
        alertConrtoller.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            DatabaseController.getContext().delete(currentUs)
            DatabaseController.saveContext()
            self.performSegue(withIdentifier: "backToUser", sender: self)
        }))
        present(alertConrtoller, animated: true, completion: nil)

    }
    
    @IBAction func makeEdits(_ sender: AnyObject) {
        enableEditing()
    }
    @IBAction func saveEdits(_ sender: AnyObject) {
                if (nameText.text != ""){
                    let alertConrtoller = UIAlertController(title: "Save Changes", message: "Are you sure you want to save changes?", preferredStyle: .alert)
                    alertConrtoller.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                        self.saveData()
                        DatabaseController.saveContext()
                        
                        self.disableEditing()
                    }))
                    alertConrtoller.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                        alertConrtoller.dismiss(animated: true, completion: nil)
                    }))
                    present(alertConrtoller, animated: true, completion: nil)
                    
                }
                else {
                    let alertConrtoller = UIAlertController(title: "Something didn't go right", message: "Nothin can be left blank", preferredStyle: .alert)
                    alertConrtoller.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                        alertConrtoller.dismiss(animated: true, completion: nil)
                    }))
                    present(alertConrtoller, animated: true, completion: nil)
                }

        }

    
    @IBAction func cancelEdits(_ sender: AnyObject) {
        let alertConrtoller = UIAlertController(title: "Stop Editing?", message: "Do you want to quit Editing?", preferredStyle: .alert)
        alertConrtoller.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            alertConrtoller.dismiss(animated: true, completion: nil)
        }))
        alertConrtoller.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.disableEditing()
            self.loadData()
        }))
        present(alertConrtoller, animated: true, completion: nil)
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


