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
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var realView: UIView!
    @IBOutlet weak var backgroundGraphic: UIImageView!
    var valueScores: [String]! = []
    override func viewDidLoad() {
        backgroundGraphic.image = UIImage(named: "Scores-\(imageNames[Int(prog)!-1])")
        imageIcon.image = UIImage(named: imageNames[Int(prog)!-1])
        backButton.layer.cornerRadius = 5

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews(){
        scoresTableView.frame = CGRect(x: scoresTableView.frame.origin.x, y: scoresTableView.frame.origin.y, width: scoresTableView.frame.size.width, height: scoresTableView.contentSize.height)
        scoresTableView.reloadData()
        styleScene()
    }
    
    func styleScene() {
        for button in buttons! {
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            
        }
    }

    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
        let scores = currentUs.scores
        for score in scores as! Set<Score> {
            if score.program! == prog {
                if score.date != "" {
                    valueScores.append("\(score.date!) \(String(score.place!)!): \(Int(score.value))/5")
                }
                
            }
            
        }
        if valueScores.count >= 1 {
            let mailComposeViewController = self.configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        }
        else {
            let alertConrtoller = UIAlertController(title: "No quizzes to send", message: "You have to take at least one quiz", preferredStyle: .alert)
            alertConrtoller.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                alertConrtoller.dismiss(animated: true, completion: nil)
            }))
            self.present(alertConrtoller, animated: true, completion: nil)
        }

    }
    
    @IBAction func backToHome(_ sender: Any) {
        self.performSegue(withIdentifier: "backToHome", sender: self)
    }
    
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setSubject("Scores for \(names[Int(prog)!-1])")
        
        

        
        var bodyString: String! = ""
        for i in 0..<valueScores.count {
            bodyString = bodyString + "\n\(valueScores[i])"
        }
        mailComposerVC.setMessageBody("Here is a report of my scores for \(names[Int(prog)!-1]): " + bodyString, isHTML: false)
        
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


