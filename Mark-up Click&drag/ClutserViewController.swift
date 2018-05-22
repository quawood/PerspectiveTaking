//
//  ClutseringViewController.swift
//  Mark-up Click&drag
//
//  Created by Qualan Woodard on 5/8/18.
//  Copyright © 2018 Pushbox, LLC'. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import SpriteKit

class ClusterViewController: UIViewController {
    
 
    @IBOutlet weak var skscene: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testlabel1.text = "user id: \(currentUs.server_id!)"
        testlabel2.text = "number of questions: \(currentUs.questions?.count)"
        
        let firstQuestion = currentUs.questions?.first(where: {_ in true}) as! Question
        testlabel3.text = "accuracy: \(firstQuestion.accuracy)"
        testlabel4.text = "attempts: \(firstQuestion.attempts)"
        testlabel5.text = "qid: \(firstQuestion.qid)"
        testlabel6.text = "total time: \(firstQuestion.totalt)"
        testlabel7.text = "average time: \(firstQuestion.tperbox)"
        testlabel8.text = "cluster: \(firstQuestion.cluster)"
        testlabel9.text = "cluster: \(currentUs.clusters)"
        
        

        let testplot2 = Plot(data: testdata2, label_color: SKColor(calibratedRed: 0.8863, green: 0.4706, blue: 0.6078, alpha: 1.0), label_marker: "o")
        testplots.append(testplot2)
        
        
        //        var testdata3:dataTuple! = elbow_method(data: Matrix(testdata1), max_n: 10)
        //        let testplot3 = Plot(data: testdata3, label_color: SKColor(calibratedRed: 0.2863, green: 0.902, blue: 0.9569, alpha: 1.0), label_marker: "o")
        //        testplots.append(testplot3)
        
        
        
        //add graph
        let testgraph = Graph(height: 400, width: 600, plots: testplots, squeeze: 0.8)
        testgraph.x_label = "random x"
        testgraph.y_label = "random y"
        testgraph.addLabels()
        testgraph.addLegend()
        skscene.addChild(testgraph)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
