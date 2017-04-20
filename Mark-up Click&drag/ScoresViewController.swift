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
   
    var imageNames:[String] = ["MC.png","MSD.png","SR1.png","SR2.png"]
    
    @IBOutlet weak var imageIcon: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var realView: UIView!
    @IBOutlet weak var backgroundGraphic: UIImageView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if !realView.frame.contains(touch.location(in: self.view)) {
            self.performSegue(withIdentifier: "backToHome", sender: self)
        }
    }
    
    override func viewDidLoad() {
        backgroundGraphic.image = UIImage(named: "Scores-\(imageNames[Int(prog)!-1])")
        imageIcon.image = UIImage(named: imageNames[Int(prog)!-1])

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
        
        mailComposerVC.setToRecipients(["info@socialskillbuilder.com"])
        mailComposerVC.setSubject("Scores for \(names[Int(prog)!-1])")
        let scores = currentUs.scores
        var valueScores: [Int]! = []
        for score in scores as! Set<Score> {
            if score.program! == prog {
                valueScores.append(Int(score.value))
            }
            
        }
        mailComposerVC.setMessageBody("Here is a report for your scores for this program: \(valueScores) ", isHTML: false)
        
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
        var scoresArray: [Score] = []
        for score in currentUs.scores! as! Set<Score> {
            if score.program! == prog {
                scoresArray.append(score)
            }
        }
        return scoresArray.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        var scoresArray: [Score] = []
        for score in currentUs.scores! as! Set<Score> {
            if score.program! == prog {
                scoresArray.append(score)
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! ScoreTableViewCell
        cell.score = scoresArray[scoresArray.count - indexPath.item - 1]
        
        return cell
    }
}


