//
//  User.swift
//  Mark-up Click&drag
//
//  Created by Qualan Woodard on 8/28/16.
//  Copyright © 2016 Pushbox, LLC'. All rights reserved.
//

import UIKit


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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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
                for _ in 1...shift {
                    array.append(array.remove(at: 0))
                }
            }
            else if (shift < 0) {
                for _ in 1...abs(shift) {
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

public class LoadingOverlay{
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView) {
        
        overlayView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        overlayView.center = view.center
        overlayView.backgroundColor = UIColor(white: 0x444444, alpha: 0.7)
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x:0, y:0, width:40, height:40)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.center = CGPoint(x:overlayView.bounds.width / 2, y:overlayView.bounds.height / 2)
        
        overlayView.addSubview(activityIndicator)
        view.addSubview(overlayView)

        
        activityIndicator.startAnimating()
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}

protocol LoadingViewControllerDelegate {
    func didFinishLoading(controller: LoadingViewController)
}

class LoadingViewController: UIViewController {
    var delegate: LoadingViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        // Do your spinner code here
    }
    
    // Delegate function, should be fired when loading is done.
    func finished() {
        if self.delegate != nil {
            self.delegate?.didFinishLoading(controller: self)
        }
    }
}

extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let coreImageColor = self.coreImageColor
        return (coreImageColor.red, coreImageColor.green, coreImageColor.blue, coreImageColor.alpha)
    }
}

extension UIButton {
    @objc dynamic var borderColor: UIColor? {
        get {
            if let cgColor = layer.borderColor {
                return UIColor(cgColor: cgColor)
            }
            return nil
        }
        set { layer.borderColor = newValue?.cgColor }
    }
    @objc dynamic var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    @objc dynamic var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
}

extension UIButton {
    func style() {
        self.cornerRadius = 3
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    
    var isThisEnabled: Bool? {
        get {
            return isUserInteractionEnabled
        }set {
            var backColor = UIColor(red: 0.562745098, green: 0.2274509804, blue: 0.1843137255, alpha: 1)
            self.isUserInteractionEnabled = newValue!
            let colorComps = [CFloat((backColor.components.red)),CFloat((backColor.components.blue)),CFloat((backColor.components.green)),CFloat((backColor.components.alpha))]
            var mincomp = CFloat()
            
            for number in colorComps {
                mincomp = min(mincomp, CFloat(CGFloat(number )))
            }
            var deltaC = CFloat(0.14)
            deltaC = deltaC - mincomp
            if newValue == true {
                backColor = UIColor(red: (CGFloat(colorComps[0] + deltaC)), green:CGFloat(colorComps[1] + deltaC), blue:CGFloat(colorComps[2] + deltaC), alpha: CGFloat(1))
                
            }
            else if newValue == false {
                backColor = UIColor(red: (CGFloat(colorComps[0] - deltaC)), green:CGFloat(colorComps[1] - deltaC), blue:CGFloat(colorComps[2] - deltaC), alpha: CGFloat(0.2))
               
            }
            UIView.animate(withDuration: 0.1, animations: {
                self.backgroundColor = backColor
            })
            
            
        }
    }
}
