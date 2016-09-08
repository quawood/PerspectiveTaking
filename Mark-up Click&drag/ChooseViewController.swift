//
//  ProgHomeViewController.swift
//  Mark-up Click&drag
//
//  Created by Qualan Woodard on 8/26/16.
//  Copyright © 2016 Pushbox, LLC'. All rights reserved.
//

import UIKit

class ChooseViewController: UIViewController {
    let colors: [UIColor] = [UIColor.colorWithRedValue(162, greenValue: 210, blueValue: 86, alpha: 1),UIColor.colorWithRedValue(195, greenValue: 99, blueValue: 74, alpha: 1),UIColor.colorWithRedValue(124, greenValue: 156, blueValue: 212, alpha: 1),UIColor.colorWithRedValue(221, greenValue: 183, blueValue: 200, alpha: 1)]
    let names: [String] = ["My Community","My School Day","School Rules 1","School Rules 2"]
    let images: [String] = ["MC.JPG","MSD.JPG","SR1.JPG","SR2.jpg"]
    var currentUser: String!
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.title = currentUs.valueForKey("name") as! String
        let vc0 = scrollinViewController(nibName: "scrollinViewController", bundle: nil)
        vc0.progImage = UIImageView(image: UIImage(named: images[0]))
      //  vc0.progName.text? = names[0]
        self.addChildViewController(vc0)
        self.scrollView.addSubview(vc0.view)
        vc0.didMoveToParentViewController(self)
        for i in 1...3 {
            let vc = scrollinViewController(nibName: "scrollinViewController", bundle: nil)
            var frame1 = vc.view.frame
            frame1.origin.x = self.view.frame.size.width * CGFloat(i)
            vc.view.frame = frame1
            
            vc.view.tag = i
            vc.view.backgroundColor = colors[i]
            vc.progImage = UIImageView(image: UIImage(named: images[i]))
            vc.progName.text = names[i]
            self.addChildViewController(vc)
            self.scrollView.addSubview(vc.view)
            vc.didMoveToParentViewController(self)

        }
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width * 4, height: self.view.frame.size.height - 66)
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
