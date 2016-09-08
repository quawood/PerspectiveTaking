//
//  UserCollectionViewCell.swift
//  Mark-up Click&drag
//
//  Created by Qualan Woodard on 9/6/16.
//  Copyright © 2016 Pushbox, LLC'. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    //MARK: - Public API
    var user: User! {
        didSet {
            updateUI()
        }
    }
    //MARK: - Private
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    func updateUI() {
        userNameLabel?.text! = user.name!
        profileImageView.image = user.profilepic
        
    }
}

class ScoreTableViewCell: UITableViewCell {
    
    var score: Score! {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var scoreValueLabel: UILabel!
    @IBOutlet weak var programLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func updateUI() {
        scoreValueLabel.text = String(score.num)
        programLabel.text = score.program
        dateLabel.text = score.date
    }
}



