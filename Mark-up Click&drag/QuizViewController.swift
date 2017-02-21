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


class QuizViewController: UIViewController, UIPopoverPresentationControllerDelegate{
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
  //  @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    var source: HomeViewController!
    var numbers = [1,2,3,4, 5]
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
    var startails: [Float]!
    var xRat: Float!
    var stars: [UIImageView] = []
    

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
            
            for i in 0...stars.count-1 {
                let starframe = CGRect(x: stars[i].frame.origin.x + scenarioView.frame.origin.x - 50 , y: stars[i].frame.origin.y +
                    scenarioView.frame.origin.y - 50, width: 100 * self.view.bounds.width/469 , height: 100 * self.view.bounds.width/469)
                if (starframe.contains(currentA.center) && (viewPlace[i] == 0||viewPlace[i] == currentA.tag)) {
                    
                    for view in currentA.subviews {
                        if let img = view as? UIImageView {
                            let k = Int(startails[i])
                            if img.tag == 0 {
                                img.highlightedImage = UIImage(named:"speechtail\(k).png")
                            }
                            else {
                                img.highlightedImage = UIImage(named: "thoughttail\(k).png")
                            }
                            
                            stars[i].isHidden = true
                            img.isHighlighted = true
                        }
                    }
                    break
                    
                }
                else {
                    for view in currentA.subviews {
                        if let img = view as? UIImageView {
                            img.isHighlighted = false
                            if viewPlace[i] == 0 {
                                stars[i].isHidden = false
                            }
                            
                            
                            
                        }
                    }
                }
            }
            
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        if currentA.frame.contains(touch.previousLocation(in: self.view)) {

            for i in 0...stars.count-1 {
                
                let starframe = CGRect(x: stars[i].frame.origin.x + scenarioView.frame.origin.x - 50, y: stars[i].frame.origin.y +
                    scenarioView.frame.origin.y - 50 , width: 100 * self.view.bounds.width/414 , height: 100 * self.view.bounds.width/469)
                if (starframe.contains(currentA.center) && (viewPlace[i] == 0||viewPlace[i] == currentA.tag)) {

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
            
            if (currentA.subviews[0] as! UIImageView).isHighlighted == false{
                currentA.frame.origin = anchors[currentA.tag-1].center
                (currentA.subviews[0] as! UIImageView).isHighlighted = false
                if viewPlace.contains(currentA.tag) {
                    viewPlace[viewPlace.index(of: currentA.tag)!] = 0
                    if viewPlace.contains(0) == true {
                        checkAnsBtn.isUserInteractionEnabled = false
                    }
                }
            }

        }
        for i in 0...stars.count - 1 {
            if viewPlace[i] == 0 {
                stars[i].isHidden = false
            }
        }
    }
    
    
    
    //setup scene
    func stylesScene() {
        homeButton.layer.cornerRadius = 5
        homeButton.titleLabel?.adjustsFontSizeToFitWidth = true
       // helpButton.layer.cornerRadius = 5
        //helpButton.titleLabel?.font = helpButton.titleLabel?.font.withSize((homeButton.titleLabel?.font.pointSize)!)
        checkAnsBtn.layer.cornerRadius = 5
        checkAnsBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        
        finishButton.titleLabel?.adjustsFontSizeToFitWidth = true
        nextQuestionBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        
    }
    func genStars() {
        var i = 0
        for starLoc in starLocations {
            i = i + 1
            let star = UIImageView()
            star.frame = CGRect(x: starLoc.x+25  , y: starLoc.y+25, width: CGFloat(19 * xRat), height: CGFloat(19 * xRat))

            star.tag = 1
            star.layer.zPosition = 9
            star.image = UIImage(named: "smallblue.png")
            stars.append(star)
            scenarioView.addSubview(star)
            
            
            
            
            
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
        for star in stars {
            star.isHidden = false
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
    
    func didFinishLoading(controller: LoadingViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func gotToHome(_ sender: AnyObject) {
        let alertConrtoller = UIAlertController(title: "Go Home", message: "Go to home and lose progress?", preferredStyle: .alert)
        alertConrtoller.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            alertConrtoller.dismiss(animated: true, completion: nil)
        }))
        alertConrtoller.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.performSegue(withIdentifier: "toHomefromQuiz", sender: self)
        }))
        present(alertConrtoller, animated: true, completion: nil)
    }
    
    func disableScene() {
        checkAnsBtn.isUserInteractionEnabled = false
        sceneView.isUserInteractionEnabled = false
        nextQuestionBtn.isUserInteractionEnabled = true
        finishButton.isUserInteractionEnabled = true
    }

    
    func GetHomeData(completionHandler: ((NSDictionary) -> Void)?)
    {
        let file = Bundle.main.path(forResource: "MCQuestions", ofType: "json")
        let url = NSURL(fileURLWithPath: file!)
        let request: NSURLRequest = NSURLRequest(url:url as URL)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        var jsonResult: [String : AnyObject]!
        
        let task : URLSessionDataTask = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
          //  var error: AutoreleasingUnsafeMutablePointer<NSError?>? = nil
            do {
                jsonResult =  try JSONSerialization.jsonObject(with: (data)!, options: .allowFragments) as! [String : AnyObject]
            } catch {
                print("error")
            }
            
            
            // then on complete I call the completionHandler...
            completionHandler?(jsonResult as NSDictionary);
        });
        task.resume()
    }
    
    func SetHomeContent()
    {
        GetHomeData(completionHandler: self.resultHandler)
    }
    
    func resultHandler(jsonResult:NSDictionary!)
    {
        json = jsonResult as! [String : AnyObject]!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        xRat  = Float(self.view.bounds.width)/469


        //source.alert.dismiss(animated: true, completion: nil)
        placeLabel.text = placeString

        scenarioView.layer.cornerRadius = 10
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
        stars=[]
        viewPlace = [0,0,0,0,0]
        var minimumFont: CGFloat = 100
       // self.view.isUserInteractionEnabled = true
        currentScore.text = String(randomNum)
        starLocations = []
        let questions = json["questions"] as! [String:AnyObject]
        let currentProgram = questions[currentProg] as! [String: AnyObject]
        let currentSpot = currentProgram[currentPlace] as! [AnyObject]
        let numm = currentSpot[randomNum-1] as! [String:AnyObject]
           if let label = numm["answers"] as? [String] , let stars = numm["stars"] as? [[Int]] , let correct = numm["correct"] as? [Int], let bubbles = numm["bubbles"] as? [String], let image = numm["image"] as? String {
             startails = numm["startails"] as? [Float]
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
                        labImages[i].tag = 0
                        //labImages[i].highlightedImage = UIImage(named: "speechtail0")
                        //labImages[i].highlightedImage = UIImage(named: "speechtail1")
                    }
                    else if bubbles[i] == "t" {
                        labImages[i].image = UIImage(named: "thought.png")
                        labImages[i].tag = 1
                    }
                }
                for j in 0...stars.count-1 {
                    
                    starLocations.append(CGPoint(x: stars[j][0] * Int(scenarioView.bounds.width) / 719, y: stars[j][1] * Int(scenarioView.bounds.height) / 469))
                }
                correctAnss = correct
                genStars()
                scenarioImg.image = UIImage(named: image)
                viewPlace = [Int](repeating:0, count:correctAnss.count)
            }
        for lab in answerLabs {
            if lab.font.pointSize < minimumFont {
                minimumFont = lab.font.pointSize
                print(minimumFont)
            }
        }
        for lab in answerLabs {
            lab.font = lab.font.withSize(minimumFont)
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
        viewPlace = [0,0,0,0,0]
        
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
                animation.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2 - 50)
                animation.bounds.size = CGSize(width: 200, height: 200)
                view.addSubview(animation)
                timer.invalidate() // just in case this button is tapped multiple times
                timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
                //rewards[randomNum-1].image = UIImage(named: "emojij\(random)")
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
           // audioPlayer.play()
            turn = turn + 1
            replaceAnswers()
            viewPlace = [Int](repeating
                :0, count:viewPlace.count)
            
        }
        else if turn == 2 {
            starLocations = []
            for i in viewPlace {
                if i != 0 {
                starLocations.append(answers[i-1].frame.origin)
                }
            }
            replaceAnswers()
            var c = 0
            for i in 1...answers.count {
                removeStars()
                if correctAnss.contains(i) {
                    c = c + 1
                    answers[i-1].frame.origin =  CGPoint(x:starLocations[correctAnss.index(of: i)!].x , y: starLocations[correctAnss.index(of: i)!].y)
                   
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
        var scoresArray: [Score]! = []
        var holderArray: [Score]! = []
        for score in currentUs.scores! as! Set<Score> {
            if score.program == prog {
                scoresArray.append(score)
            } else {
                holderArray.append(score)
            }
        }
       
        let components = calendar.dateComponents([.month,.day,.year], from: date as Date)
        let score: Score = NSEntityDescription.insertNewObject(forEntityName: "Score", into: DatabaseController.getContext()) as! Score
       score.value = Int16(correct)
        score.date = "\(components.month!)/\(components.day!)/\(components.year!)"
        score.program = prog
        score.place = placeString
        
        if scoresArray.count == 5 {
            scoresArray = scoresArray.rotate(shift: 1)
            scoresArray[scoresArray.count-1] = score
        }
        else if scoresArray.count == 1 && Int(scoresArray[0].value) == 0{
            scoresArray[0] = score
        }
        else {
            scoresArray.append(score)
        }
        
        currentUs.scores = NSSet(array: (scoresArray + holderArray))
        
        
        
        DatabaseController.saveContext()

        self.performSegue(withIdentifier: "toHomefromQuiz", sender: self)
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


