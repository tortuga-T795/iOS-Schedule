//
//  StringHandle.swift
//  curriculum
//
//  Created by IvanLyuhtikov on 10/27/19.
//  Copyright © 2019 IvanLyuhtikov. All rights reserved.
//

import Foundation
import UIKit

var day = 0

func searchByRegularExpresion(regularEx: String, str: String) -> [String] {
    var arr = [String]()
    
    var copy = str
    while copy != "" {
        if let mess = copy.range(of: regularEx, options: .regularExpression) {
            arr.append(String(copy[mess]))
            let range = Range(uncheckedBounds: (lower: copy.startIndex, upper: mess.upperBound))
            copy.removeSubrange(range)
        } else {
            copy = ""
        }
    }
    return arr
}

func curriculumDayFinal(_ str: String) -> [CurriculumDay] {
    
    
    let newStr = str.replacingOccurrences(of: #"11223344556677"#, with: "", options: .regularExpression)
    
    var arrayOfCurric = [CurriculumDay]()
    var arrayOfPareNumbers = searchByRegularExpresion(regularEx: #"\d{1,}\s+[А-Я]"#, str: newStr)
    var arrayOfPares = searchByRegularExpresion(regularEx: #"\d{1,}\s+\b[А-Я](\w+)?[А-Я]*([а-я])?(\([А-я]*)?\b"#, str: newStr) //?
    var arrayOfTeachers = searchByRegularExpresion(regularEx:
        #"\d+\s+[А-Яа-я]+\s+([A-ZА-Я][a-zа-я]{1,}(\s)?([A-ZА-Я])?(\.)?([A-ZА-Я])?)(\.)?\s+(([A-ZА-Я][a-zа-я]{1,}\s([A-ZА-Я])?(\.)?([A-ZА-Я])?)(\.)?)?"#, str: newStr)
    var arrayOfRooms = searchByRegularExpresion(regularEx: #"[^\-]\b(\d{3}|\d{2}([а-я])?)\b"#, str: newStr) //?
    
    
    arrayOfPareNumbers = arrayOfPareNumbers.map({ (str) in
           str.replacingOccurrences(of: #"\s+[А-Я]"#, with: "", options: .regularExpression)
       })
    
    
    arrayOfPares = arrayOfPares.map({ (str) in
        str.replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: #"\W+"#, with: "", options: .regularExpression).replacingOccurrences(of: #"\d{1,}"#, with: "", options: .regularExpression)
    })
    
   // print(arrayOfRooms)
    arrayOfRooms = arrayOfRooms.map( { (str) in
        str.replacingOccurrences(of: "\t", with: "")
        })
    var count = 0
    var delCount = 0
    for  _ in arrayOfRooms {
        if count % 2 == 1
        {
            arrayOfRooms.remove(at: count - delCount)
            delCount += 1
        }
        count += 1
    }
    
    print(arrayOfRooms)
    
    
    arrayOfTeachers = arrayOfTeachers.map({ (str) in
        str.replacingOccurrences(of: #"\d+\s+[А-Яа-я]+\s+"#, with: "", options: .regularExpression).replacingOccurrences(of: #"\t+"#, with: "", options: .regularExpression).replacingOccurrences(of: #"\s+"#, with: "  ", options: .regularExpression)
    })
    
    print(arrayOfTeachers)
   
    
    for (index, _) in arrayOfPareNumbers.enumerated() {
        arrayOfPareNumbers[index] = String(arrayOfPareNumbers[index].last!)
    }
    
    let arrayOfGroups = searchByRegularExpresion(regularEx: #"\b[А-Я]-\d{2,3}\b"#, str: newStr)
    
    print(newStr)
    
    
    for i in 0..<arrayOfPareNumbers.count {
        
        
        print( arrayOfPareNumbers[i])
        if day == 5 {
            arrayOfPareNumbers[i].append(" \(timePare[1][(Int(arrayOfPareNumbers[i])!-1)])")
        }
        else {
        arrayOfPareNumbers[i].append(" \(timePare[0][(Int(arrayOfPareNumbers[i])!-1)])")
        }
    }
    
//    print(day)
    day += 1
    
    
    for (index, _) in arrayOfPares.enumerated() {
        arrayOfCurric.append(("\(arrayOfPares[index])",
                            "\(arrayOfTeachers[index])",
                            "\(arrayOfRooms[index])",
                            "\(arrayOfGroups[index])",
            "\(arrayOfPareNumbers[index])"))
    }
    return arrayOfCurric
}
