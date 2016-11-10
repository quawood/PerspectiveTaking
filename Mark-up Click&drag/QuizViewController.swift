//
//  ViewController.swift
//  SSB
//
//  Created by Qualan Woodard on 7/7/16.
//  Copyright © 2016 Qualan Woodard. All rights reserved.
//

import UIKit
import QuartzCore
import AVFoundation
import CoreData
import Foundation


class QuizViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    var placeString: String!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var sceneView: UIView!
    @IBOutlet var labImages: [UIImageView]!
    @IBOutlet var anchors: [UIView]!
    @IBOutlet var answers: [UIView]!
    @IBOutlet var answerLabs: [UILabel]!
    @IBOutlet weak var scenarioView: UIView!
    @IBOutlet var rewards: [UIImageView]!
    @IBOutlet weak var scenarioImg: UIImageView!
    @IBOutlet weak var nextQuestionBtn: UIButton!
    @IBOutlet weak var checkAnsBtn: UIButton!
    @IBOutlet weak var clearAnswerBtn: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var currentScore: UILabel!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    
    var numbers = [4,6, 8, 9, 10]
    let date = NSDate()
    let calendar = NSCalendar.current
    var counter = 0
    var timer = Timer()
    var correct:Int = 0
    
    var starLocations:[CGPoint]!
    var correctAnss:[Int]!
    var viewPlace:[Int] = [0,0,0,0,0]
    var randomNum:Int = 1
    
    var currentA = UIView()
    var touch:UITouch!
    var deltaX: CGFloat!
    var deltaY: CGFloat!

    var turn: Int = 1
    var animation:UIImageView!
    var audioPlayer:AVAudioPlayer!
    
    // JSON Setup
    var json: [String:AnyObject]!
    
    var currentPlace:String! = "1"
    var currentProg:String! = "my_community"
    
    @IBAction func unwindToQuiz(_ segue: UIStoryboardSegue) {
        
    }
    
    //Touch controllers
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = touches.first! 
        for a in answers {
            if a.frame.contains(touch.previousLocation(in: self.view)) {
                currentA = a
                deltaX = touch.location(in: self.view).x - currentA.center.x
                deltaY = touch.location(in: self.view).y - currentA.center.y
                currentA.center = CGPoint(x: touch.location(in: self.view).x - deltaX, y: touch.location(in: self.view).y - deltaY)
                
            }
        }
    }
    

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentA.frame.contains(touch.previousLocation(in: self.view)) {
            currentA.center = CGPoint(x: touch.location(in: self.view).x-deltaX, y: touch.location(in: self.view).y-deltaY)
            
            for i in 0...starLocations.count-1 {
                let starframe = CGRect(x: starLocations[i].x + scenarioView.frame.origin.x , y: starLocations[i].y +
                    scenarioView.frame.origin.y , width: 55 * self.view.bounds.width/414 , height: 55 * self.view.bounds.width/414)
                if (starframe.contains(touch.previousLocation(in: self.view)) && viewPlace[i] == 0) {
                    
                    for view in currentA.subviews {
                        if let img = view as? UIImageView {
                            img.isHighlighted = true
                        }
                    }
                    break
                    
                }
                else {
                    for view in currentA.subviews {
                        if let img = view as? UIImageView {
                            img.isHighlighted = false
                        }
                    }
                }
            }
            
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentA.frame.contains(touch.previousLocation(in: self.view)) {

            for i in 0...starLocations.count-1 {
                let starframe = CGRect(x: starLocations[i].x + scenarioView.frame.origin.x , y: starLocations[i].y +
                    scenarioView.frame.origin.y , width: 55 * self.view.bounds.width/414 , height: 55 * self.view.bounds.width/414)
                if (starframe.contains(touch.previousLocation(in: self.view)) && viewPlace[i] == 0) {
                    
                    currentA.frame.origin = CGPoint(x:starLocations[i].x + scenarioView.frame.origin.x - 15 , y: starLocations[i].y +
                        scenarioView.frame.origin.y - 15)
                    if viewPlace.contains(currentA.tag) {
                        viewPlace[viewPlace.index(of: currentA.tag)!] = 0
                    }
                    viewPlace[i] = currentA.tag
                    
                    if viewPlace.contains(0) == false {
                        checkAnsBtn.isUserInteractionEnabled = true
                    }
                    break
                    
                }
            }
            
            if starLocations.contains(CGPoint(x: currentA.frame.origin.x - scenarioView.frame.origin.x + 15, y: currentA.frame.origin.y - scenarioView.frame.origin.y + 15)) == false{
                currentA.frame.origin = anchors[currentA.tag-1].center
                if viewPlace.contains(currentA.tag) {
                    viewPlace[viewPlace.index(of: currentA.tag)!] = 0
                    if viewPlace.contains(0) == true {
                        checkAnsBtn.isUserInteractionEnabled = false
                    }
                }
            }

        }
    }
    
    
    
    //setup scene
    func stylesScene() {
        homeButton.layer.cornerRadius = 5
        homeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        helpButton.layer.cornerRadius = 5
        helpButton.titleLabel?.font = helpButton.titleLabel?.font.withSize((homeButton.titleLabel?.font.pointSize)!)
        checkAnsBtn.layer.cornerRadius = 5
        checkAnsBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        
        finishButton.titleLabel?.adjustsFontSizeToFitWidth = true
        nextQuestionBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        
    }
    func genStars() {
        for starLoc in starLocations {
            let star = UIImageView()
            star.frame = CGRect(x: starLoc.x + 12, y: starLoc.y + 12, width: 25 * self.view.bounds.width/414, height: 25 * self.view.bounds.width/414)
            star.tag = 1
            star.layer.zPosition = 9
            
            scenarioView.addSubview(star)
            star.image = UIImage(named: "smallblue.png")
            
            
        }
    }
    
    func replaceAnswers() {
        for i in 0...answers.count-1 {
            answers[i].frame.origin = anchors[i].center
            for view in answers[i].subviews as [UIView]{
                if let img = view as? UIImageView {
                    img.isHighlighted = false
                }
            }
        }
        viewPlace = [Int](repeating:0, count:viewPlace.count)
        checkAnsBtn.isUserInteractionEnabled = false
    }
    
    func removeStars() {
        for view in scenarioView.subviews {
            if let star = view as? UIImageView {
                if star.tag == 1 {
                    star.removeFromSuperview()
                }
            }
        }
    }
    
    
    @IBAction func gotToHome(_ sender: AnyObject) {
        let alertConrtoller = UIAlertController(title: "Go Home", message: "Go to home and lose progress?", preferredStyle: .alert)
        alertConrtoller.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            alertConrtoller.dismiss(animated: true, completion: nil)
        }))
        alertConrtoller.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.performSegue(withIdentifier: "backToHome", sender: self)
        }))
        present(alertConrtoller, animated: true, completion: nil)
    }
    
    func disableScene() {
        checkAnsBtn.isUserInteractionEnabled = false
        sceneView.isUserInteractionEnabled = false
        nextQuestionBtn.isUserInteractionEnabled = true
        finishButton.isUserInteractionEnabled = true
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeLabel.text = placeString

        scenarioView.layer.cornerRadius = 10
        let file = Bundle.main.path(forResource: "MCQuestions", ofType: "json")
        let url = NSURL(fileURLWithPath: file!)
        let data = NSData(contentsOf: url as URL)
        do {
            json = try JSONSerialization.jsonObject(with: data! as Data, options:.allowFragments) as! [String:AnyObject]
        } catch {
            //couldn't load
        }
        
        
        let tryAgain = NSURL(fileURLWithPath: Bundle.main.path(forResource: "try-again_test", ofType: "wav")!)
        do {
            let sound = try AVAudioPlayer(contentsOf: (tryAgain as NSURL) as URL)
            audioPlayer = sound
        } catch {
            //couldn't load file
        }
        nextQuestion()
        if answerLabs[4].text == "" {
            answers[4].isHidden = true
        }
        else {
            answers[4].isHidden = false
        }
        replaceAnswers()
        stylesScene()
        
    }
    


    //Question controllers

    func nextQuestion() {
       // self.view.isUserInteractionEnabled = true
        currentScore.text = String(randomNum)
        let urlString = "MCQuestions.json"
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            if error != nil {
                print(error)
            } else {
                do {
                    
                    self.json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any] as Dictionary<String, AnyObject>!
                } catch let error as NSError {
                    print(error)
                }
            }
            
        }).resume()
        starLocations = []
        let questions = json["questions"] as! [String:AnyObject]
        let currentProgram = questions[currentProg] as! [String: AnyObject]
        let currentSpot = currentProgram[currentPlace] as! [AnyObject]
        let numm = currentSpot[randomNum-1] as! [String:AnyObject]
           if let label = numm["answers"] as? [String] , let stars = numm["stars"] as? [[Int]] , let correct = numm["correct"] as? [Int], let bubbles = numm["bubbles"] as? [String], let image = numm["image"] as? String {
                for i in 0...answerLabs.count-1 {
                    answerLabs[i].text = label[i]
                    answers[i].layer.zPosition = 10
                    if answerLabs[i].text == "" {
                        answers[i].isHidden = true
                    }
                    else {
                        answers[i].isHidden = false
                    }
                    
                    if bubbles[i] == "s" {
                        labImages[i].image = UIImage(named: "speech.png")
                        labImages[i].highlightedImage = UIImage(named: "speechr.png")
                    }
                    else if bubbles[i] == "t" {
                        labImages[i].image = UIImage(named: "thought.png")
                        labImages[i].highlightedImage = UIImage(named: "thoughtr.png")
                        
                    }
                }
                for j in 0...stars.count-1 {
                    
                    starLocations.append(CGPoint(x: stars[j][0] * Int(scenarioView.bounds.width) / 719, y: stars[j][1] * Int(scenarioView.bounds.height) / 479))
                }
                correctAnss = correct
                genStars()
                scenarioImg.image = UIImage(named: image)
                viewPlace = [Int](repeating:0, count:correctAnss.count)
            }
        
    }
    
    
    @IBAction func clearAnswers(sender: AnyObject) {
        replaceAnswers()
    }
    
    @IBAction func nextQuestion(sender: AnyObject) {
        sceneView.isUserInteractionEnabled = true
        removeStars()
        turn = 1
        replaceAnswers()
        randomNum += 1
        nextQuestionBtn.isHidden = true
        
        checkAnsBtn.isUserInteractionEnabled = false
        if animation != nil {
            animation.removeFromSuperview()
        }
        if randomNum != 6 {
            nextQuestion()
        }
        if answerLabs[4].text == "" {
            answers[4].isHidden = true
        }
        else {
            answers[4].isHidden = false
        }
        
    }
    


    
    @IBAction func checkAns(sender: AnyObject) {
        if viewPlace == correctAnss {
            //nextQuestionBtn.isHidden = false
            if turn == 1 {
                let random = numbers[Int(arc4random_uniform(UInt32(numbers.count-1)))]
                numbers.remove(at: numbers.index(of: random)!)
                print(numbers.count)
                animation = UIImageView(image:UIImage.gif(name: "emoji\(random)"))
                animation.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
                animation.bounds.size = CGSize(width: 200, height: 200)
                view.addSubview(animation)
                timer.invalidate() // just in case this button is tapped multiple times
                timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
                rewards[randomNum-1].image = UIImage(named: "emojij\(random)")
                correct = correct + 1
                disableScene()
            }
            if randomNum != 5 {
                nextQuestionBtn.isHidden = false
                nextQuestionBtn.isUserInteractionEnabled = true
            }
            else {
                finishButton.isHidden = false
            }
        }
        else if turn == 1 {
            audioPlayer.play()
            turn = turn + 1
            replaceAnswers()
            viewPlace = [Int](repeating
                :0, count:viewPlace.count)
            
        }
        else if turn == 2 {
            replaceAnswers()
            for i in 1...answers.count {
                if correctAnss.contains(i) {
                    answers[i-1].frame.origin =  CGPoint(x:starLocations[correctAnss.index(of: i)!].x + scenarioView.frame.origin.x , y: starLocations[correctAnss.index(of: i)!].y +
                        scenarioView.frame.origin.y)
                   
                    answers[i-1].isUserInteractionEnabled = false
                }
            }
            disableScene()
            //self.view.isUserInteractionEnabled = false
            
            if randomNum != 5 {
                nextQuestionBtn.isHidden = false
                nextQuestionBtn.isUserInteractionEnabled = true
            }
            else {
                finishButton.isHidden = false
                finishButton.isUserInteractionEnabled = true
            }
        }
    }
    
    func timerAction() {
        timer.invalidate()
        animation.removeFromSuperview()
    }
    @IBAction func saveScore(sender: AnyObject) {
        
        // Populate Address
       // score.setValue("\(components.month)/\(components.day)/\(components.year)", forKey: "date")
       // score.setValue(currentProg, forKey: "program")
        var placeHolder = (currentUs.value(forKey: "scores\(currentProg!)") as! [Int])
        if placeHolder.count == 5 {
            placeHolder = placeHolder.rotate(shift: 1)
            placeHolder[placeHolder.count-1] = correct
        }
        else if placeHolder.count == 1 && placeHolder[0] == 0{
            placeHolder[0] = correct
        }
        else {
          placeHolder.append(correct)
        }
        
        currentUs.setValue(placeHolder, forKey: "scores\(currentProg!)")
        
        do {
            try currentUs.managedObjectContext?.save()
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
    }

    
    @IBAction func menuPopover(sender: AnyObject) {
        self.performSegue(withIdentifier: "showMenu", sender: self)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMenu" {
            let vc = segue.destination
            vc.preferredContentSize = CGSize(width: 300, height: 300)
            let controller = vc.popoverPresentationController
            if controller != nil {
                controller?.delegate = self
            }
        }
    }
    
    
    
}


