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


class QuizViewController: AudioViewController, UIPopoverPresentationControllerDelegate{
    var placeString: String!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var sceneView: UIView!
    @IBOutlet var anchors: [UIView]!
    @IBOutlet var answers: [AnswerView]!
    @IBOutlet weak var scenarioView: UIView!
    @IBOutlet weak var scenarioImg: UIImageView!
    @IBOutlet weak var nextQuestionBtn: UIButton!
    @IBOutlet weak var checkAnsBtn: UIButton!
    @IBOutlet weak var clearAnswerBtn: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var currentScore: UILabel!
  //  @IBOutlet weak var helpButton: UIButton!
    var quizPlayer = AVQueuePlayer()
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var nextToContLbl: UILabel!
    var source: HomeViewController!
    var numbers = [1,2,3,4, 5]
    let date = NSDate()
    let calendar = NSCalendar.current
    var counter = 0
    
    var timer = Timer()
    var correct:Int = 0
    
    var progName: String!
    @IBOutlet weak var ProgramLabel: UILabel!
    
    var starLocations:[CGPoint]!
    var correctAnss:[Int]!
    var viewPlace:[Int] = [0,0,0,0,0]
    var randomNum:Int!
    var isSceneEnabled:Bool! = true
    var currentA = AnswerView()
    var touch:UITouch!
    var deltaX: CGFloat!
    var deltaY: CGFloat!

    var turn: Int = 1
    var animation:UIImageView!

    
    // JSON Setup
    var json: [String:AnyObject]!
    var currentPlace:String! = "1"
    var currentProg:String! = "my_community"
    var startails: [Float]!
    var xRat: Float!
    var stars: [UIImageView] = []
    
    
    //collecting data
    var globalTimer = Timer()
    var timeCounter: Float = 0

    //Touch controllers
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isSceneEnabled {
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
        
    }
    

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isSceneEnabled {
            if currentA.frame.contains(touch.previousLocation(in: self.view)) {
                currentA.center = CGPoint(x: touch.location(in: self.view).x-deltaX, y: touch.location(in: self.view).y-deltaY)
                
                for i in 0...stars.count-1 {
                    let starframe = CGRect(x: stars[i].frame.origin.x + scenarioView.frame.origin.x - 25 , y: stars[i].frame.origin.y +
                        scenarioView.frame.origin.y - 25, width: 75 * self.view.bounds.width/469 , height: 75 * self.view.bounds.width/469)
                    if (starframe.contains(currentA.center) && (viewPlace[i] == 0||viewPlace[i] == currentA.tag)) {
                        
                        let k = Int(startails[i])
                        if currentA.answerImage.tag == 0 {
                            currentA.answerImage.highlightedImage = UIImage(named:"speechtail\(k).png")
                        }
                        else {
                            currentA.answerImage.highlightedImage = UIImage(named: "thoughttail\(k).png")
                        }
                        
                        stars[i].isHidden = true
                        currentA.answerImage.isHighlighted = true
                        break
                        
                    }
                    else {
                        
                        currentA.answerImage.isHighlighted = false
                        if viewPlace[i] == 0 {
                            stars[i].isHidden = false
                        }
                        
                        
                        
                    }
                }
                
            }
        }

    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isSceneEnabled {
            
            if currentA.frame.contains(touch.previousLocation(in: self.view)) {
                
                for i in 0...stars.count-1 {
                    
                    let starframe = CGRect(x: stars[i].frame.origin.x + scenarioView.frame.origin.x - 25, y: stars[i].frame.origin.y +
                        scenarioView.frame.origin.y - 25 , width: 75 * self.view.bounds.width/414 , height: 75 * self.view.bounds.width/469)
                    if (starframe.contains(currentA.center) && (viewPlace[i] == 0||viewPlace[i] == currentA.tag)) {
                        
                        if viewPlace.contains(currentA.tag) {
                            viewPlace[viewPlace.index(of: currentA.tag)!] = 0
                        }
                        viewPlace[i] = currentA.tag
                        
                        if viewPlace.contains(0) == false {
                            checkAnsBtn.isThisEnabled = true
                        }
                        break
                        
                    }
                    
                }
                
                if currentA.answerImage.isHighlighted == false{
                    currentA.frame.origin = anchors[currentA.tag-1].center
                    currentA.answerImage.isHighlighted = false
                    if viewPlace.contains(currentA.tag) {
                        viewPlace[viewPlace.index(of: currentA.tag)!] = 0
                        if viewPlace.contains(0) == true {
                            checkAnsBtn.isThisEnabled = false
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

    }
    

    
    //setup scene
    func stylesScene() {
        homeButton.layer.cornerRadius = 3
        homeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        finishButton.layer.cornerRadius = 3
        nextQuestionBtn.layer.cornerRadius = 3
       // helpButton.layer.cornerRadius = 5
        //helpButton.titleLabel?.font = helpButton.titleLabel?.font.withSize((homeButton.titleLabel?.font.pointSize)!)
        checkAnsBtn.layer.cornerRadius = 3
        checkAnsBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        
        finishButton.titleLabel?.adjustsFontSizeToFitWidth = true
        nextQuestionBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        scenarioView.layer.cornerRadius = 10
        for answer in answers {
            answer.answerText.textColor = UIColor(red: 0.2666666667, green: 0.5960784314, blue: 0.8274509804, alpha: 1)
        }
        
    }
    func genStars() {
        var i = 0
        for starLoc in starLocations {
            i = i + 1
            let star = UIImageView()
            star.frame = CGRect(x: starLoc.x  , y: starLoc.y, width: CGFloat(19 * xRat), height: CGFloat(19 * xRat))

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

            answers[i].answerImage.isHighlighted = false
        }
        for star in stars {
            star.isHidden = false
        }
        viewPlace = [Int](repeating:0, count:viewPlace.count)
        checkAnsBtn.isThisEnabled = false
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
        let alertConrtoller = UIAlertController(title: "Go Home", message: "Go to home? Your progress will be saved, but the score will not be reported.", preferredStyle: .alert)
        alertConrtoller.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            alertConrtoller.dismiss(animated: true, completion: nil)
        }))
        alertConrtoller.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.saveState()
            self.performSegue(withIdentifier: "toHomefromQuiz", sender: self)
        }))
        present(alertConrtoller, animated: true, completion: nil)
    }
    
    func disableScene() {
        checkAnsBtn.isThisEnabled = false
        isSceneEnabled = false
 
        clearAnswerBtn.isUserInteractionEnabled = false
    }

    
    func GetHomeData(completionHandler: ((NSDictionary) -> Void)?)
    {
        let file = Bundle.main.path(forResource: "questions", ofType: "json")
        let url = NSURL(fileURLWithPath: file!)
        let request: NSURLRequest = NSURLRequest(url:url as URL)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        var jsonResult: [String : AnyObject]!
        print(url)
        
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
        
        ProgramLabel.text = progName
        
        xRat  = Float(self.view.bounds.width)/469


        //source.alert.dismiss(animated: true, completion: nil)
        placeLabel.text = placeString

        
        nextQuestion()
        if answers[4].answerText.text == "" {
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
        isSceneEnabled = true
        checkAnsBtn.isThisEnabled = false

        clearAnswerBtn.isUserInteractionEnabled = true
        
        for answer in answers {
            answer.answerText.textColor = UIColor(red: 0.2666666667, green: 0.5960784314, blue: 0.8274509804, alpha: 1)
        }
        stars=[]
        viewPlace = [0,0,0,0,0]
        var minimumFont: CGFloat = 100
       // self.view.isUserInteractionEnabled = true
        currentScore.text = String(randomNum)
        starLocations = []
        SetHomeContent()
        let questions = json["questions"] as! [String:AnyObject]
        let currentProgram = questions[currentProg] as! [String: AnyObject]
        let currentSpot = currentProgram[currentPlace] as! [AnyObject]
        let numm = currentSpot[randomNum-1] as! [String:AnyObject]
           if let label = numm["answers"] as? [String] , let stars = numm["stars"] as? [[Int]] , let correct = numm["correct"] as? [Int], let bubbles = numm["bubbles"] as? [String], let image = numm["image"] as? String {
            
             startails = numm["startails"] as? [Float]
                for i in 0...answers.count-1 {
                    answers[i].answerText.text = label[i]
                    
                    answers[i].layer.zPosition = 10
                    if answers[i].answerText.text == "" {
                        answers[i].isHidden = true
                        
                    }
                    else {
                        answers[i].isHidden = false
                    }
                    
                    if bubbles[i] == "s" {
                        answers[i].answerImage.image = UIImage(named: "speech.png")
                        answers[i].answerImage.tag = 0
                    }
                    else if bubbles[i] == "t" {
                        answers[i].answerImage.image = UIImage(named: "thought.png")
                        answers[i].answerImage.tag = 1
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
        for lab in answers {
            if lab.answerText.font.pointSize < minimumFont {
                minimumFont = lab.answerText.font.pointSize
            }
        }
        for lab in answers {
            lab.answerText.font = lab.answerText.font.withSize(minimumFont)
        }
        
    }
    
    
    @IBAction func clearAnswers(sender: AnyObject) {
        replaceAnswers()
    }
    
    @IBAction func nextQuestion(sender: AnyObject) {
        removeStars()
        turn = 1
        replaceAnswers()
        randomNum = randomNum + 1
        UIView.animate(withDuration: 0.5, animations: {
            self.nextQuestionBtn.frame.origin.x = self.view.frame.width
            self.nextQuestionBtn.isHidden = true
            
        })
        nextToContLbl.text = "Press NEXT to continue"
        nextToContLbl.isHidden = true
        viewPlace = [0,0,0,0,0]
        
        checkAnsBtn.isThisEnabled = false
        if animation != nil {
            animation.removeFromSuperview()
        }
        if randomNum != 6 {
            nextQuestion()
        }
        if answers[4].answerText.text == "" {
            answers[4].isHidden = true
        }
        else {
            answers[4].isHidden = false
        }
        self.audioPlayer.stop()
        if currentUs.isAudioEnabled {
            self.quizPlayer.removeAllItems()
        }
        
    }
    
    func playSound(filename: String) {
        self.playAudio(fileName: filename)
    }

    func playInSequence(soundsArray: [String]) {
        if currentUs.isAudioEnabled {
            self.audioPlayer.stop()
            var audioItems: [AVPlayerItem] = []
            for audioName in soundsArray {
                let url = NSURL(fileURLWithPath: Bundle.main.path(forResource: audioName, ofType: "wav")!)
                let item = AVPlayerItem(url: url as URL)
                audioItems.append(item)
            }
            
            quizPlayer = AVQueuePlayer(items: audioItems)
            quizPlayer.play()
        }
 
    }
    
    @IBAction func checkAns(sender: AnyObject) {
        let goodAudios:[String] = ["Great job","Perfect","Wow Super job","You are good at this"]
        let badAudios:[String] = ["Take another look","That's okay Try again", "That's okay"]
        let neutral:[String] = ["correctSound", "wrongSound"]
        globalTimer.invalidate()
        if viewPlace == correctAnss {
            let randomIndex = Int(arc4random_uniform(UInt32(goodAudios.count)))
            playInSequence(soundsArray:[neutral[0], goodAudios[randomIndex]])
            if turn == 1 {
                let random = numbers[Int(arc4random_uniform(UInt32(numbers.count)) + 1) - 1]
                numbers.remove(at: numbers.index(of: random)!)
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
                disableScene()
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.nextQuestionBtn.frame.origin.x = self.homeButton.frame.origin.x
                    self.nextQuestionBtn.isHidden = false
                    self.nextToContLbl.isHidden = false
                    self.nextToContLbl.text = "Press NEXT to continue"
                    
                })

            }
            else {
                disableScene()
                UIView.animate(withDuration: 0.5, animations: {
                    self.finishButton.frame.origin.x = self.homeButton.frame.origin.x
                    self.finishButton.isHidden = false
                    self.nextToContLbl.isHidden = false
                    self.nextToContLbl.text = "Press FINISH to go home"
                    
                })
            }
        }
        else if turn == 1 {
            
            let randomIndex = Int(arc4random_uniform(UInt32(badAudios.count-1)))
            playInSequence(soundsArray: [neutral[1], badAudios[randomIndex]])
            turn = turn + 1
            replaceAnswers()
            viewPlace = [Int](repeating
                :0, count:viewPlace.count)
            
        }
        else if turn == 2 {
            playInSequence(soundsArray: [neutral[1], "That's okay"])
            
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
                    let k = Int(startails[correctAnss.index(of: i)!])
                    if answers[i-1].answerImage.tag == 0 {
                        answers[i-1].answerImage.highlightedImage = UIImage(named:"cspeechtail\(k).png")
                    }else {
                        answers[i-1].answerImage.highlightedImage = UIImage(named:"cthoughttail\(k).png")
                    }
                    
                    answers[i-1].answerText.textColor = UIColor.black
                    answers[i-1].answerImage.isHighlighted = true
                }
            }
            disableScene()
            //self.view.isUserInteractionEnabled = false
            
            if randomNum != 5 {
                UIView.animate(withDuration: 0.5, animations: {
                    self.nextQuestionBtn.frame.origin.x = self.homeButton.frame.origin.x
                    self.nextQuestionBtn.isHidden = false
                    self.nextToContLbl.isHidden = false
                    self.nextToContLbl.text = "Here are the correct answers - press NEXT to continue"
                    
                })
            }
            else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.finishButton.frame.origin.x = self.homeButton.frame.origin.x
                    self.finishButton.isHidden = false
                    self.nextToContLbl.isHidden = false
                    self.nextToContLbl.text = "Here are the correct answers - Press FINISH to go home"
                    
                })
            }
        }
    }
    
    @objc func timerAction() {
        timer.invalidate()
        animation.removeFromSuperview()
    }
    
    func saveState() {
        var found: Bool = false
        var progressesArray = currentUs.progresses as? Set<Progress>
        let progress: Progress = NSEntityDescription.insertNewObject(forEntityName: "Progress", into: DatabaseController.getContext()) as! Progress
        progress.value = Int16(randomNum-1)
        progress.place = currentPlace
        progress.program = prog
        if (progressesArray?.count)! > 0 {
            for p in progressesArray! {
                if (p.place! == currentPlace) && (p.program! == prog) {
                        progressesArray?[(progressesArray?.index(of: p))!].value = progress.value
                    found = true
                    break
                    
                }
                
            }
            if !found {
               progressesArray?.insert(progress)
            }
            
            
        }else {
            progressesArray?.insert(progress)
        }
        
        currentUs.progresses = progressesArray as NSSet?
        DatabaseController.saveContext()
        
    }
    @IBAction func saveScore(sender: AnyObject) {
        
        var usedC: Int! = 1
       
        let components = calendar.dateComponents([.month,.day,.year], from: date as Date)
        let score: Score = NSEntityDescription.insertNewObject(forEntityName: "Score", into: DatabaseController.getContext()) as! Score
       score.value = Int16(correct)
        score.date = "\(components.month!)/\(components.day!)/\(components.year!)"
        score.program = prog
        score.place = placeString
        
        
        var scoresArray: [Score]! = []
        var holderArray: [Score]! = []
        for scorec in currentUs.scores! as! Set<Score> {
            if scorec.program == prog {
                scoresArray.append(scorec)
                if scorec.place == placeString {
                    usedC = usedC + 1
                }
            } else {
                holderArray.append(scorec)
            }
        }
        score.id = Int16(scoresArray.count)
        scoresArray = scoresArray.sorted(by: {$0.id < $1.id})
        score.attempt = Int16(usedC)
        
        if scoresArray.count == 15 {
            scoresArray = scoresArray.rotate(shift: 1)
            score.id = Int16(scoresArray.count)
            scoresArray[scoresArray.count-1] = score

        }
        else if scoresArray.count == 1 && Int(scoresArray[0].value) == 0{
            scoresArray[0] = score
        }
        else {
            scoresArray.append(score)
        }
        
        currentUs.scores = NSSet(array: (scoresArray + holderArray))
        randomNum = 6
        saveState()
        
        
        DatabaseController.saveContext()
        self.performSegue(withIdentifier: "toHomefromQuiz", sender: self)
        //self.performSegue(withIdentifier: "toHomefromQuiz", sender: self)
        
        
        
        let total_time = timeCounter
        let star_num = stars.count
        let average_time = timeCounter/Float(star_num)
        
        
    }
    func startcollectData() {
        
        //start timer
        globalTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        var starsnum = stars.count
        
    }
    
    func updateTimer() {
        timeCounter = timeCounter + 0.1
    }
    
    func uploadData(_ sender: Any) {
        let request = NSMutableURLRequest(url: NSURL(string: "https://quiet-hollows-94770.herokuapp.com/share.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "a=3&b=3"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            print("response = \(response)")
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(responseString)")
        }
        task.resume()
        
    }
    
    
    @IBAction func menuPopover(sender: AnyObject) {
        self.performSegue(withIdentifier: "showMenu", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.audioPlayer.stop()
        if self.quizPlayer.isPlaying{
            self.quizPlayer.removeAllItems()
        }
        if segue.identifier == "toHomefromQuiz" {
            
            let vc = segue.destination as! HomeViewController
            vc.program = currentProg
            
        }
    }
    
    
    
}


extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
