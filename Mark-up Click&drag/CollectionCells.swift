//
//  UserCollectionViewCell.swift
//  Mark-up Click&drag
//
//  Created by Qualan Woodard on 9/6/16.
//  Copyright © 2016 Pushbox, LLC'. All rights reserved.
//

import UIKit
import CoreData
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
    var score: Score! {
        didSet {
            updateUI()
        }
    }
    //MARK: - Private
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var scoreNameLabel: UILabel!
    @IBOutlet weak var dateNameLabel: UILabel!
    func updateUI() {
        placeNameLabel.text = score.place
        scoreNameLabel.text = String(describing: score.value) + "/5"
        dateNameLabel.text = score.date
    }
    
}




