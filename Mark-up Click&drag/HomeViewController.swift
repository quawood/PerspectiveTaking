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
class HomeViewController: UIViewController{
    
    
    @IBOutlet weak var programTitle: UILabel!
    @IBOutlet weak var programImage: UIImageView!
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
        programTitle.text = names[Int(program)! - 1]
        prog = program
        programImage.image = UIImage(named: images[Int(program)! - 1])
      //  programLabel.text = names[Int(program)!-1]3
          
        

    }
    func saveState() {
        var progressesArray = currentUs.progresses as? Set<Progress>
        let progress: Progress = NSEntityDescription.insertNewObject(forEntityName: "Progress", into: DatabaseController.getContext()) as! Progress
        progress.value = Int16(randomNum-1)
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
        if randomNum != 1 {
        let alertConrtoller = UIAlertController(title: "Start Quiz", message: "Start over or resume from where you left off.", preferredStyle: .alert)
        alertConrtoller.addAction(UIAlertAction(title: "Start Over", style: .cancel, handler: { (action: UIAlertAction!) in
            self.randomNum = 1
            self.saveState()
            self.performSegue(withIdentifier: "toQuiz", sender: self)
        }))
        alertConrtoller.addAction(UIAlertAction(title: "Resume", style: .default, handler: { (action: UIAlertAction!) in
            self.performSegue(withIdentifier: "toQuiz", sender: self)
        }))
        present(alertConrtoller, animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "toQuiz", sender: self)
        }
    }

    @IBAction func goNextAction(_ sender: AnyObject) {
        alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        alert.view.tintColor = UIColor.black
        activityIndicator.startAnimating()
        DispatchQueue.main.async {
            self.clearOrResume()
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuiz"
        {
            
            let destinationVC = segue.destination as! QuizViewController
            destinationVC.currentProg = program
            destinationVC.currentPlace = place
            destinationVC.placeString = placeString
            destinationVC.randomNum = randomNum
            destinationVC.SetHomeContent()
            activityIndicator.stopAnimating()

            
            
           
            
        }
    }
    
}
