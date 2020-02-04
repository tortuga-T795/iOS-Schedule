//
//  WeekSwitcher.swift
//  curriculum
//
//  Created by IvanLyuhtikov on 1/30/20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

import UIKit
import AudioUnit

func getAttributedString(text: String, foregroundColor: UIColor, font: UIFont) -> NSAttributedString {
    return NSAttributedString(string: text,
                              attributes: [NSAttributedString.Key.foregroundColor : foregroundColor,
                                           NSAttributedString.Key.font : font as Any])
}

enum ActivePosition: Int {
    case first = 0, second = 1
}

class WeekSwitcher: UIControl {
    

    var buttons: [UIButton]!
    var active: ActivePosition = .first {
        didSet {
            let indecator: Int
            
            if active == .first {
                indecator = 0
            } else {
                indecator = 1
            }
            for i in buttons {
                i.isSelected = false
                i.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
                self.buttons[indecator].transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }) { (comp) in
                self.buttons[indecator].isSelected = true
                AudioServicesPlaySystemSound(1519)
            }
        }
    }
    var stack: UIStackView!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("bounds = \(bounds)")
        stack.frame = bounds
        clipsToBounds = true
        layer.cornerRadius = 10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let firstButton = UIButton(type: .custom)
        let secondButton = UIButton(type: .custom)
        
        let firstAttributedStr: NSAttributedString = getAttributedString(text: "Сейчас",
                                                                         foregroundColor: #colorLiteral(red: 0.9433895946, green: 0.9221940637, blue: 0.9005565643, alpha: 1),
                                                                         font: UIFont(name: "Dreamcast", size: 16)!)
            
        let secondAttributedStr: NSAttributedString = getAttributedString(text: "Следующая",
                                                                          foregroundColor: #colorLiteral(red: 0.9433895946, green: 0.9221940637, blue: 0.9005565643, alpha: 1),
                                                                          font: UIFont(name: "Dreamcast", size: 16)!)
        
        let firstChangeAttrStr: NSAttributedString = getAttributedString(text: "Сейчас",
                                                                         foregroundColor: .red,
                                                                         font: UIFont(name: "Dreamcast", size: 16)!)
        
        
        let secondChangeAttrStr: NSAttributedString = getAttributedString(text: "Следующая",
                                                                          foregroundColor: .red,
                                                                          font: UIFont(name: "Dreamcast", size: 16)!)
        
        firstButton.setAttributedTitle(firstAttributedStr, for: .normal)
        firstButton.setAttributedTitle(firstChangeAttrStr, for: .selected)
        firstButton.tag = 0
        secondButton.setAttributedTitle(secondAttributedStr, for: .normal)
        secondButton.setAttributedTitle(secondChangeAttrStr, for: .selected)
        secondButton.tag = 1
        buttons = [firstButton, secondButton]
        
        stack = UIStackView(arrangedSubviews: buttons)
        
        addSubview(stack)
        
        stack.spacing = 8
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //...
    }
    
    

}


