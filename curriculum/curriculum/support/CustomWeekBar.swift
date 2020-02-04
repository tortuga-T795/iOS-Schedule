//
//  CustomWeekBar.swift
//  curriculum
//
//  Created by IvanLyuhtikov on 1/29/20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

import UIKit

protocol CustomWeekBarDelegate: class {
    func countOf() -> Int
    func namesOf() -> [String]
}

class CustomWeekBar: UIControl {
    
    weak var VC: ViewController!
    weak open var delegate: CustomWeekBarDelegate? {
        didSet {
            delegateRelease()
        }
    }
    
    var selectedIndex: Int = 0 {
        willSet {
            selectedButton(sender: nil, index: newValue)
        }
    }
    
    private var arrOfButtons: [UIButton] = [UIButton]()
    private var stack: UIStackView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("bounds = \(bounds)")
        stack.frame = bounds
        clipsToBounds = true
        layer.cornerRadius = 15
    }
    
    
    func delegateRelease() {
        let count = delegate?.countOf() ?? 0
        let names = delegate?.namesOf()
        
        self.backgroundColor = #colorLiteral(red: 0.1383914351, green: 0.1330786645, blue: 0.1663919389, alpha: 1)
        
        for i in 0..<count {
            let button = UIButton(type: .custom)
            
            let attributedStr: NSAttributedString = NSAttributedString(string: names?[i] ?? "",
                                                                       attributes: [NSAttributedString.Key.foregroundColor : UIColor.white,
                                                                                    NSAttributedString.Key.font : UIFont(name: "Dreamcast", size: 30) as Any])
            let attributedStrSelect: NSAttributedString = NSAttributedString(string: names?[i] ?? "",
                                                                             attributes: [NSAttributedString.Key.foregroundColor : UIColor.red,
                                                                                          NSAttributedString.Key.font : UIFont(name: "Dreamcast", size: 30) as Any])
            button.setAttributedTitle(attributedStr, for: .normal)
            button.tag = i
            button.setAttributedTitle(attributedStrSelect, for: .selected)
            arrOfButtons.append(button)
        }
        
        stack = UIStackView(arrangedSubviews: arrOfButtons)
        self.addSubview(stack)
        
        stack.spacing = 8
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
    }
    
    func subsribeButtons(closure: @escaping (UIButton) -> ()) {
        for i in arrOfButtons {
            closure(i)
        }
    }
    
    
    @objc func selectedButton(sender: UIButton?, index: Int) {
        
        print(selectedIndex)
        for i in arrOfButtons {
            i.isSelected = false
            i.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        let button = arrOfButtons[sender?.tag ?? index]
        
        UIView.animate(withDuration: 0.15, animations: {
            button.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (comp) in
            button.isSelected = true
        }
        
        
        //...
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        print("draw")
        //...
    }
    

}
