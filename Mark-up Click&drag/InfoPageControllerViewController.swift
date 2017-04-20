//
//  InfoPageControllerViewController.swift
//  Mark-up Click&drag
//
//  Created by Qualan Woodard on 12/13/16.
//  Copyright © 2016 Pushbox, LLC'. All rights reserved.
//

import UIKit
import MessageUI
var isAudioEnabled: Bool = true
class InfoPageControllerViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func toggleAudio(_ sender: Any) {
        isAudioEnabled = !isAudioEnabled
    }
    @IBAction func goToWebsiteBtn(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "http://www.socialskillbuilder.com/")!)
    }

    @IBAction func contactUsBtn(_ sender: Any) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["social@skillbuilder.com"])
        mailComposerVC.setSubject("")
        
        /*for score in scores {
         valueScores.append(score.value)
         }*/
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    @IBAction func faqsbtn(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "http://www.socialskillbuilder.com/social-skill-builder-software-frequently-asked-questions/")!)
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
