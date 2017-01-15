//
//  ScoresViewController.swift
//  Mark-up Click&drag
//
//  Created by Qualan Woodard on 10/28/16.
//  Copyright © 2016 Pushbox, LLC'. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
class ScoresViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var scoresTableView: UITableView!
    @IBOutlet weak var scoresLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var realView: UIView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if !realView.frame.contains(touch.location(in: self.view)) {
            self.performSegue(withIdentifier: "backToHome", sender: self)
        }
    }
    
    override func viewDidLoad() {
        scoresTableView.layer.borderColor = UIColor(red: 23/255, green: 57/255, blue: 100/255, alpha: 1.0).cgColor
        scoresTableView.layer.borderWidth = 2
        scoresTableView.layer.cornerRadius = 5
        scoresLabel.text = "Scores for \(names[Int(prog)!-1])"
        containerView.layer.cornerRadius = 15

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews(){
        scoresTableView.frame = CGRect(x: scoresTableView.frame.origin.x, y: scoresTableView.frame.origin.y, width: scoresTableView.frame.size.width, height: scoresTableView.contentSize.height)
        scoresTableView.reloadData()
    }

    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
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
        
        mailComposerVC.setToRecipients(["someone@somewhere.com"])
        mailComposerVC.setSubject("Scores for \(names[Int(prog)!-1])")
        let scores = currentUs.value(forKey: "scores\(prog!)") as! [Float]
        /*for score in scores {
            valueScores.append(score.value)
        }*/
        mailComposerVC.setMessageBody("\(scores)", isHTML: false)
        
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
}

extension ScoresViewController:UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (currentUs.value(forKey: "scores\(prog!)") as! [Float]).count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! ScoreTableViewCell
       cell.textLabel?.text = "\(Int((currentUs.value(forKey: "scores\(prog!)") as! [Float])[(currentUs.value(forKey: "scores\(prog!)") as! [Float]).count-indexPath.item-1]))"
        //cell.score = (value(forKey: "scores\(prog!)") as! [ScoreClass])[indexPath.item]
        return cell
    }
}


