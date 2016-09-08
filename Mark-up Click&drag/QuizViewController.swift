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
    
    let date = NSDate()
    let calendar = NSCalendar.currentCalendar()
    
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
    var json: AnyObject!
    
    var currentPlace:String! = "restaurant"
    var currentProg:String! = "my_community"
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touch = touches.first! 
        for a in answers {
            if a.frame.contains(touch.previousLocationInView(self.view)) {
                currentA = a
                deltaX = touch.locationInView(self.view).x - currentA.center.x
                deltaY = touch.locationInView(self.view).y - currentA.center.y
                currentA.center = CGPoint(x: touch.locationInView(self.view).x - deltaX, y: touch.locationInView(self.view).y - deltaY)
                
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if currentA.frame.contains(touch.previousLocationInView(self.view)) {
            currentA.center = CGPoint(x: touch.locationInView(self.view).x-deltaX, y: touch.locationInView(self.view).y-deltaY)
            
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if currentA.frame.contains(touch.previousLocationInView(self.view)) {

            for i in 0...starLocations.count-1 {
                let starframe = CGRect(x: starLocations[i].x + scenarioView.frame.origin.x, y: starLocations[i].y +
                    scenarioView.frame.origin.y , width: 100 , height: 100)
                if (starframe.contains(touch.previousLocationInView(self.view)) && viewPlace[i] == 0 && !viewPlace.contains(currentA.tag))||(viewPlace[i] == currentA.tag) {
                    
                    currentA.center = starframe.origin
                    viewPlace[i] = currentA.tag
                    
                    if viewPlace.contains(0) == false {
                        checkAnsBtn.userInteractionEnabled = true
                    }
                    break
                    
                }
            }
            
            if starLocations.contains(CGPoint(x: currentA.center.x - scenarioView.frame.origin.x, y: currentA.center.y - scenarioView.frame.origin.y)) == false{
                currentA.frame.origin = anchors[currentA.tag-1].center
            }

        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        replaceAnswers()
        let file = NSBundle.mainBundle().pathForResource("MCQuestions", ofType: "json")
        let url = NSURL(fileURLWithPath: file!)
        let data = NSData(contentsOfURL: url)
        json = try! NSJSONSerialization.JSONObjectWithData(data! as NSData, options: [])
        nextQuestion()
        let tryAgain = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("try-again_test", ofType: "wav")!)
        do {
            let sound = try AVAudioPlayer(contentsOfURL: tryAgain as NSURL)
            audioPlayer = sound
        } catch {
            //couldn't load file
        }
    }
    
    

    func genStars() {
        for starLoc in starLocations {
            let star = UIImageView()
            star.frame = CGRect(x: starLoc.x, y: starLoc.y, width: 10, height: 10)
            star.tag = 1
            star.layer.zPosition = 9
            
            scenarioView.addSubview(star)
            star.image = UIImage(named: "smallblue.png")

            
        }
    }
    
    func removeStars() {
        for view in self.view.subviews {
            if let star = view as? UIImageView {
                if star.tag == 1 {
                    star.removeFromSuperview()
                }
            }
        }
    }
    
    func replaceAnswers() {
        for i in 0...answers.count-1 {
            answers[i].frame.origin = anchors[i].center
        }
        viewPlace = [Int](count:viewPlace.count, repeatedValue:0)
        checkAnsBtn.userInteractionEnabled = false
    }
    
    func nextQuestion() {
        starLocations = []
            if let label = json?["questions"]??[currentProg]??[currentPlace]??[randomNum-1]["answers"] as? [String] , let stars = json?["questions"]??[currentProg]??[currentPlace]??[randomNum-1]["stars"] as? [[Int]] , let correct = json?["questions"]??[currentProg]??[currentPlace]??[randomNum-1]["correct"] as? [Int], let bubbles = json?["questions"]??[currentProg]??[currentPlace]??[randomNum-1]["bubbles"] as? [String] {
                for i in 0...answerLabs.count-1 {
                    answerLabs[i].text = label[i]
                    answers[i].layer.zPosition = 10
                    
                    if bubbles[i] == "s" {
                        labImages[i].image = UIImage(named: "speacha.png")
                    }
                    else if bubbles[i] == "t" {
                        labImages[i].image = UIImage(named: "thoughta.png")
                    }
                }
                for j in 0...stars.count-1 {
                    
                    starLocations.append(CGPoint(x: stars[j][0] * Int(scenarioView.bounds.width) / 531, y: stars[j][1] * Int(scenarioView.bounds.height) / 458))
                }
                correctAnss = correct
                genStars()
                viewPlace = [Int](count:correctAnss.count, repeatedValue:0)
            }
        
    }
    
    
    @IBAction func clearAnswers(sender: AnyObject) {
        replaceAnswers()
    }
    
    @IBAction func nextQuestion(sender: AnyObject) {
        removeStars()
        turn = 1
        replaceAnswers()
        randomNum += 1
        nextQuestionBtn.hidden = true
        nextQuestionBtn.userInteractionEnabled = false
        
        checkAnsBtn.userInteractionEnabled = false
        if animation != nil {
            animation.removeFromSuperview()
        }
        if randomNum != 6 {
            nextQuestion()
        }
        if answerLabs[4].text == "" {
            answerLabs[4].userInteractionEnabled = false
            answerLabs[4].backgroundColor = UIColor.clearColor()
        }
        else {
            answerLabs[4].userInteractionEnabled = true
            answerLabs[4].backgroundColor = UIColor(red: 249, green: 252, blue: 255, alpha: 1)
        }
        
    }

    
    @IBAction func checkAns(sender: AnyObject) {
        if viewPlace == correctAnss {
            nextQuestionBtn.hidden = false
            if turn == 1 {
                animation = UIImageView(image: UIImage(named: "janimation\(randomNum)"))
                animation.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
                view.addSubview(animation)
                rewards[randomNum-1].image = UIImage(named: "janimation\(randomNum)")
                correct = correct + 1
                currentScore.text = "\(correct) / 5"
            }
            if randomNum != 5 {
                nextQuestionBtn.hidden = false
                nextQuestionBtn.userInteractionEnabled = true
            }
            else {
                finishButton.hidden = false
                finishButton.userInteractionEnabled = true
            }
        }
        else if turn < 3 {
            audioPlayer.play()
            turn = turn + 1
            replaceAnswers()
            viewPlace = [Int](count:viewPlace.count, repeatedValue:0)
            
        }
        else if turn == 3 {
            replaceAnswers()
            for i in 1...answers.count {
                if correctAnss.contains(i) {
                    answers[i-1].center = starLocations[correctAnss.indexOf(i)!]
                    answers[i-1].userInteractionEnabled = false
                }
            }
            if randomNum != 5 {
                nextQuestionBtn.hidden = false
                nextQuestionBtn.userInteractionEnabled = true
            }
            else {
                finishButton.hidden = false
                finishButton.userInteractionEnabled = true
            }
        }
    }
    
    @IBAction func saveScore(sender: AnyObject) {
        
        let components = calendar.components([.Month, .Day, .Year], fromDate: date)
        let entity = NSEntityDescription.entityForName("Score", inManagedObjectContext: managedObjectContext)
        let score = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        
        // Populate Address
        score.setValue("\(components.month)/\(components.day)/\(components.year)", forKey: "date")
        score.setValue(Float(correct), forKey: "num")
        score.setValue(currentProg, forKey: "program")

        currentUs.setValue(NSSet(object: score), forKey: "scores")
        
        do {
            try currentUs.managedObjectContext?.save()
        } catch {
            let saveError = error as NSError
            print(saveError)
        }  
    }

    
    @IBAction func menuPopover(sender: AnyObject) {
        self.performSegueWithIdentifier("showMenu", sender: self)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMenu" {
            let vc = segue.destinationViewController
            vc.preferredContentSize = CGSize(width: 300, height: 300)
            let controller = vc.popoverPresentationController
            if controller != nil {
                controller?.delegate = self
            }
        }
    }
    
    @IBAction func finishedSeg(sender: AnyObject) {
     //   scores.append(correct)
        correct = 0
    }
    
    
    
}

