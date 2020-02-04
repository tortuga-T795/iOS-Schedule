//
//  Element.swift
//  curriculum
//
//  Created by IvanLyuhtikov on 2/1/20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

import RealmSwift

class Element: Object {
    @objc dynamic var pare: String = ""
    @objc dynamic var teacher: String = ""
    @objc dynamic var room: String = ""
    @objc dynamic var group: String = ""
    @objc dynamic var numberPare: String = ""
    
    convenience init(p: String, t: String, r: String, g: String, n: String) {
        self.init()
        self.pare = p
        self.teacher = t
        self.room = r
        self.group = g
        self.numberPare = n
    }
}

class Day: Object {
    let storage = List<Element>()
    
    func getMultyArr() -> [[String]] {
        var res = [[String]]()
        for one in storage {
            var arr = [String]()
            arr.append(one.pare)
            arr.append(one.teacher)
            arr.append(one.room)
            arr.append(one.group)
            arr.append(one.numberPare)
            res.append(arr)
        }
        return res
    }
}


