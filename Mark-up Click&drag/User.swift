//
//  User.swift
//  Mark-up Click&drag
//
//  Created by Qualan Woodard on 8/28/16.
//  Copyright © 2016 Pushbox, LLC'. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var dateCreated: String = ""
    var scores: [Int]!
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
    
    
}



// 1
class AllowedCharsTextField: UITextField, UITextFieldDelegate {
    
    // 2
    @IBInspectable var allowedChars: String = ""
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // 3
        delegate = self
        // 4
        autocorrectionType = .no
    }
    
    // 5
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // 6
        guard string.characters.count > 0 else {
            return true
        }
        
        // 7
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return prospectiveText.containsOnlyCharactersIn(matchCharacters: allowedChars)
    }
    
}


// 8
extension String {
    
    // Returns true if the string contains only characters found in matchCharacters.
    func containsOnlyCharactersIn(matchCharacters: String) -> Bool {
        let disallowedCharacterSet = NSCharacterSet(charactersIn: matchCharacters).inverted
        return self.rangeOfCharacter(from: disallowedCharacterSet) == nil
    }
    
}

extension Array {
    func rotate(shift:Int) -> Array {
        var array = Array()
        if (self.count > 0) {
            array = self
            if (shift > 0) {
                for i in 1...shift {
                    array.append(array.remove(at: 0))
                }
            }
            else if (shift < 0) {
                for i in 1...abs(shift) {
                    array.insert(array.remove(at: array.count-1),at:0)
                }
            }
        }
        return array
    }
}

class Star: NSObject {
    func contains(answer: UIView) {
        
    }
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.index(startIndex, offsetBy: i)]
    }
    
}
