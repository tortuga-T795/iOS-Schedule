//
//  Enums.swift
//  curriculum
//
//  Created by IvanLyuhtikov on 10/16/19.
//  Copyright © 2019 IvanLyuhtikov. All rights reserved.
//

import UIKit


//Probably in Future)
enum StateOfPare {
    case normal
    case none
}

enum Weeks {
    static let firstWeek = "первая неделя"
    static let secondWeek = "вторая неделя"
}

struct Fonts {
    static let dreamcast = "Dreamcast"
}

enum StringIdentifierCell {
    static let dayCell = "DayCell"
    static let nilCell = "NilCell"
    static let defCell = "DefaultCell"
}

struct SearchVC {
    static let SEARCH_HEIGHT: CGFloat = CONSTANT_HEIGHT/2
    static let SEARCH_WIDTH: CGFloat = CONSTANT_WIDTH-40
    
    static let FrameY: CGFloat = CONSTANT_HEIGHT/15
    static let FrameX: CGFloat = 20
    
    static let FRAME: CGRect = CGRect(x: SearchVC.FrameX, y: SearchVC.FrameY, width: SearchVC.SEARCH_WIDTH, height: SearchVC.SEARCH_HEIGHT)
}

struct Colors {
    
    static let brightOrange     = UIColor(red: 255.0/255.0, green: 69.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    static let red              = UIColor(red: 255.0/255.0, green: 115.0/255.0, blue: 115.0/255.0, alpha: 1.0)
    static let orange           = UIColor(red: 255.0/255.0, green: 175.0/255.0, blue: 72.0/255.0, alpha: 1.0)
    static let blue             = UIColor(red: 74.0/255.0, green: 144.0/255.0, blue: 228.0/255.0, alpha: 1.0)
    static let green            = UIColor(red: 91.0/255.0, green: 197.0/255.0, blue: 159.0/255.0, alpha: 1.0)
    static let darkGrey         = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
    static let veryDarkGrey     = UIColor(red: 13.0/255.0, green: 13.0/255.0, blue: 13.0/255.0, alpha: 1.0)
    static let lightGrey        = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0)
    static let black            = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    static let white            = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
}
