//
//  ChooseProgramViewController.swift
//  Mark-up Click&drag
//
//  Created by Qualan Woodard on 8/26/16.
//  Copyright © 2016 Pushbox, LLC'. All rights reserved.
//
import CoreData
import UIKit
var prog: String!
class HomeViewController: AudioViewController{
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var graphicImage: UIImageView!
    var programTitle: String!
    @IBOutlet weak var contentView: UIView!
    var program: String!
    var place: String!
    var placeString: String!
    var alert: UIAlertController!
    @IBOutlet weak var goNextButton: UIButton!
    var data: [String:AnyObject]!
    var randomNum: Int!
    var images: [String] = ["MC.JPG", "MSD.JPG","SR1.JPG","SR2.JPG"]
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    

    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        graphicImage.image = UIImage(named: "CWT\(Int(program!)! - 1)")
        print("CWT\(program!)")
        programTitle = names[Int(program)! - 1]
        prog = program
        
        backButton.layer.cornerRadius = 5
      //  programLabel.text = names[Int(program)!-1]3
          
        

    }
    func startOver() {
        var progressesArray = currentUs.progresses as? Set<Progress>
        let progress: Progress = NSEntityDescription.insertNewObject(forEntityName: "Progress", into: DatabaseController.getContext()) as! Progress
        progress.value = Int16(0)
        progress.place = place
        progress.program = prog
        if (progressesArray?.count)! > 0 {
            for p in progressesArray! {
                if (p.place == place) && (p.program == prog) {
                    if progressesArray?[(progressesArray?.index(of: p))!].value != 5 {
                        progressesArray?[(progressesArray?.index(of: p))!].value = progress.value
                    }
                    
                    break
                }
                progressesArray?.insert(progress)
            }
        }else {
            progressesArray?.insert(progress)
        }
        
        currentUs.progresses = progressesArray as NSSet?
        DatabaseController.saveContext()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        goNextButton.isHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clearOrResume() {
        if randomNum > 1  {
        let alertConrtoller = UIAlertController(title: "Start Quiz", message: "Start over or resume from where you left off.", preferredStyle: .alert)
        alertConrtoller.addAction(UIAlertAction(title: "Start Over", style: .cancel, handler: { (action: UIAlertAction!) in
            self.randomNum = 1
            self.startOver()
            self.activityIndicator.startAnimating()
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toQuiz", sender: self)
            }
            
        }))
        alertConrtoller.addAction(UIAlertAction(title: "Resume", style: .default, handler: { (action: UIAlertAction!) in
            self.activityIndicator.startAnimating()
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toQuiz", sender: self)
            }
            
        }))
        present(alertConrtoller, animated: true, completion: nil)
        } else if randomNum == 1 {
            activityIndicator.startAnimating()
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toQuiz", sender: self)
            }
            
        } else if randomNum == 0 {
            let alertConrtoller = UIAlertController(title: "Retake Quiz", message: "Restart and retake quiz?", preferredStyle: .alert)
            alertConrtoller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                alertConrtoller.dismiss(animated: true, completion: nil)
            }))
            alertConrtoller.addAction(UIAlertAction(title: "Retake", style: .default, handler: { (action: UIAlertAction!) in
                self.randomNum = 1
                self.startOver()
                self.activityIndicator.startAnimating()
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toQuiz", sender: self)
                }
                
                
            }))
            present(alertConrtoller, animated: true, completion: nil)
        }
    }

    @IBAction func goNextAction(_ sender: AnyObject) {
        alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        alert.view.tintColor = UIColor.black
        clearOrResume()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "openProgram" {
            self.audioPlayer.stop()
        }
        if segue.identifier == "toQuiz"
        {
            
            let destinationVC = segue.destination as! QuizViewController
            destinationVC.currentProg = program
            destinationVC.currentPlace = place
            destinationVC.placeString = placeString
            destinationVC.randomNum = randomNum
            destinationVC.progName = programTitle
            destinationVC.SetHomeContent()
            
            activityIndicator.stopAnimating()

            
            
           
            
        }
    }
    
}
