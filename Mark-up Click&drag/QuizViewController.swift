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

class QuizViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var scores = [NSManagedObject]()
    
    
    
    @IBOutlet weak var scenarioView: CustomView!
    @IBOutlet weak var answerView1: CustomView!
    @IBOutlet weak var answerView2: CustomView!
    @IBOutlet weak var answerView3: CustomView!
    @IBOutlet weak var answerView4: CustomView!
    @IBOutlet weak var answerView5: CustomView!
    @IBOutlet weak var questionLab: UILabel!
    @IBOutlet weak var scenarioImg: UIImageView!
    @IBOutlet weak var answerLab1: UILabel!
    @IBOutlet weak var answerLab2: UILabel!
    @IBOutlet weak var answerLab3: UILabel!
    @IBOutlet weak var answerLab4: UILabel!
    @IBOutlet weak var answerLab5: UILabel!
    
    @IBOutlet weak var nextQuestionBtn: CustomButton!
    @IBOutlet weak var checkAnsBtn: CustomButton!
    @IBOutlet weak var clearAnswerBtn: CustomButton!
    @IBOutlet weak var finishButton: CustomButton!
    
    @IBOutlet weak var rewardIcon1: UIImageView!
    @IBOutlet weak var rewardIcon2: UIImageView!
    @IBOutlet weak var rewardIcon3: UIImageView!
    @IBOutlet weak var rewardIcon4: UIImageView!
    @IBOutlet weak var rewardIcon5: UIImageView!
    var rewardIcons:[UIImageView]!
    
    var correct:Int = 0
    
    var starLocations:[CGPoint]!
    var correctAnss:[Int]!
    var startingPos:[CGPoint]!
    
    var answerViews:[CustomView]!
    var viewPlace:[Int] = [0,0,0,0,0]
    var randomNum:Int = 1
    
    var currentA = CustomView()
    var touch:UITouch!
    var deltaX: CGFloat!
    var deltaY: CGFloat!
    
    var turn: Int = 1
    var animation:UIImageView!
    var audioPlayer:AVAudioPlayer!
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = touches.first!
        for a in answerViews {
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
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentA.frame.contains(touch.previousLocation(in: self.view)) {
            for i in 0...starLocations.count-1 {
                if (CGRect(origin: starLocations[i], size: CGSize(width: 50, height: 50)).contains(currentA.center) && viewPlace[i] == 0 && !viewPlace.contains(currentA.tag))||(viewPlace[i] == currentA.tag) {
                    currentA.center = starLocations[i]
                    viewPlace[i] = currentA.tag
                    
                    if viewPlace.contains(0) == false {
                        checkAnsBtn.isUserInteractionEnabled = true
                    }
                    break
                    
                }
            }
            if starLocations.contains(currentA.center) == false{
                currentA.center = startingPos[currentA.tag - 1]
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.landscape
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        answerViews = [answerView1,answerView2,answerView3,answerView4,answerView5]
        rewardIcons = [rewardIcon1,rewardIcon2,rewardIcon3,rewardIcon4,rewardIcon5]
        startingPos = [answerView1.center,answerView2.center,answerView3.center,answerView4.center,answerView5.center]
        nextQuestion()
        let tryAgain = NSURL(fileURLWithPath: Bundle.main.path(forResource: "try-again_test",ofType:"wav")!)
        do {
            let sound = try AVAudioPlayer(contentsOf: tryAgain as URL)
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
            view.addSubview(star)
           // star.image = UIImage(named: "smallblue.png")
            
            
            
        }
    }
    
    func removeStars() {
        for view in self.view.subviews as! [UIView] {
            if let star = view as? UIImageView {
                if star.tag == 1 {
                    star.removeFromSuperview()
                }
            }
        }
    }
    
    func replaceAnswers() {
        for i in 0...answerViews.count-1 {
            answerViews[i].center = startingPos[i]
        }
        viewPlace = [Int](repeating:0,count:viewPlace.count)
        checkAnsBtn.isUserInteractionEnabled = false
    }
    
    func nextQuestion() {

        switch(randomNum){
        case 1:
            questionLab.text = "Waiting for seats."
            answerLab1.text = "He is so embarassing."
            answerLab2.text = "Where are you going?"
            answerLab3.text = "I love you."
            answerLab4.text = "I hate this sitting and waiting."
            answerLab5.text = "You are waiting so well."
            scenarioImg.image = UIImage(named: "P1010119.jpg")
            
            starLocations = [CGPoint(x: 111, y: 120),CGPoint(x: 250, y: 286),CGPoint(x: 321, y: 98),CGPoint(x: 435, y: 194)]
            genStars()
            correctAnss = [4,1,5,2]
            viewPlace = [0,0,0,0]
            
            
        case 2:
            questionLab.text = "Almost have seats."
            answerLab1.text = "Are we next on the list?"
            answerLab2.text = "Sure you can see the list."
            answerLab3.text = "I will call you when we are ready."
            answerLab4.text = "I like to wait."
            answerLab5.text = ""
            scenarioImg.image = UIImage(named: "P1010120.jpg")
            
            starLocations = [CGPoint(x: 116, y: 214),CGPoint(x: 299, y: 138)]
            genStars()
            correctAnss = [3,1]
            viewPlace = [0,0]
            
            
            
        case 3:
            questionLab.text = "Waiting for seats"
            answerLab1.text = "He is hurting my ears."
            answerLab2.text = "Where's the bathroom?"
            answerLab3.text = "SHHH!"
            answerLab4.text = "I am ready to order."
            answerLab5.text = "I can't believe he is being so loud."
            scenarioImg.image = UIImage(named: "P1010129.jpg")
        
            starLocations = [CGPoint(x: 88, y: 188),CGPoint(x: 164, y: 62),CGPoint(x: 365, y: 83)]
            genStars()
            correctAnss = [3,1,5]
            viewPlace = [0,0,0]
            
            
        
        case 4:
            questionLab.text = "Waiting for seats"
            answerLab1.text = "Oh, I found it."
            answerLab2.text = "Where is it?"
            answerLab3.text = "I really like your food."
            answerLab4.text = "Wait, What do you need?"
            answerLab5.text = ""
            scenarioImg.image = UIImage(named: "P1010131.jpg")
            
            starLocations = [CGPoint(x: 116, y: 154),CGPoint(x: 218, y: 66)]
            genStars()
            correctAnss = [2,4]
            viewPlace = [0,0]
            
            
        
        case 5:
            questionLab.text = "Waiting for seats"
            answerLab1.text = "What are you doing?"
            answerLab2.text = "You are so rude."
            answerLab3.text = "My sister is in trouble."
            answerLab4.text = "You kids are so good."
            answerLab5.text = ""
            scenarioImg.image = UIImage(named: "P1010132.jpg")
            
            starLocations = [CGPoint(x: 116, y: 154),CGPoint(x: 242, y: 64),CGPoint(x: 439, y: 119)]
            genStars()
            correctAnss = [1,2,3]
            viewPlace = [0,0,0]
            
        
        default:
            break
        }
        
    }
    
    
    @IBAction func clearAnswers(_ sender: AnyObject) {
        replaceAnswers()
    }
    
    @IBAction func nextQuestion(_ sender: AnyObject) {
        removeStars()
        turn = 1
        replaceAnswers()
        randomNum += 1
        nextQuestionBtn.isHidden = true
        nextQuestionBtn.isUserInteractionEnabled = false
        
        checkAnsBtn.isUserInteractionEnabled = false
        if animation != nil {
            animation.removeFromSuperview()
        }
        if randomNum != 6 {
            nextQuestion()
        }
        if answerLab5.text == "" {
            answerLab5.isUserInteractionEnabled = false
            answerLab5.backgroundColor = UIColor.white
        }
        else {
            answerLab5.isUserInteractionEnabled = true
            answerLab5.backgroundColor = UIColor(red: 249, green: 252, blue: 255, alpha: 1)
        }
        
    }

    
    @IBAction func checkAns(_ sender: AnyObject) {
        if viewPlace == correctAnss {
            nextQuestionBtn.isHidden = false
            if turn == 1 {
                animation = UIImageView(image: UIImage.gifWithName(name: "animation\(randomNum)"))
                animation.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
                view.addSubview(animation)
                rewardIcons[randomNum-1].image = UIImage(named: "janimation\(randomNum)")
                correct = correct + 1
            }
            if randomNum != 5 {
                nextQuestionBtn.isHidden = false
                nextQuestionBtn.isUserInteractionEnabled = true
            }
            else {
                finishButton.isHidden = false
                finishButton.isUserInteractionEnabled = true
            }
        }
        else if turn < 3 {
            audioPlayer.play()
            turn = turn + 1
            replaceAnswers()
            viewPlace = [Int](repeating: 0, count:viewPlace.count)
            
        }
        else if turn == 3 {
            replaceAnswers()
            for i in 1...answerViews.count {
                if correctAnss.contains(i) {
                    answerViews[i-1].center = starLocations[correctAnss.index(of: i)!]
                    answerViews[i-1].isUserInteractionEnabled = false
                }
            }
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
    
    
    @IBAction func menuPopover(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "showMenu", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMenu" {
            let vc = segue.destination
            vc.preferredContentSize = CGSize(width: 300, height: 150)
            let controller = vc.popoverPresentationController
            if controller != nil {
                controller?.delegate = self
            }
        }
    }
    
    @IBAction func finishedSeg(_ sender: AnyObject) {
     //   scores.append(correct)
        correct = 0
    }
    
    
    
}

