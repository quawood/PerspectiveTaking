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
    @IBOutlet weak var userNameLabel: UILabel!
    func updateUI() {
        userNameLabel?.text! = user.name!
        
    }
}

class ScoreTableViewCell: UITableViewCell {
    //MARK: - Public API
    var score: ScoreClass! {
        didSet {
            updateUI()
        }
    }
    //MARK: - Private
    
    @IBOutlet weak var programNameLabel: UILabel!
    @IBOutlet weak var scoreNameLabel: UILabel!
    @IBOutlet weak var dateNameLabel: UILabel!
    func updateUI() {
        programNameLabel.text = score.fromProgram
        scoreNameLabel.text = String(score.value)
        dateNameLabel.text = score.dateCreated
    }
    
}




