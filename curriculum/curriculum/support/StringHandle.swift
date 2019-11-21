//
//  StringHandle.swift
//  curriculum
//
//  Created by IvanLyuhtikov on 10/27/19.
//  Copyright © 2019 IvanLyuhtikov. All rights reserved.
//

import Foundation

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
        #"(\s+[А-Я][а-я]+\s+)?\b[А-Я][а-я]+\s([А-Я]|[A-Z])(\.)?([А-Я]|[A-Z])(\.)?(\s+[А-Я][а-я]+\s([А-Я]|[A-Z])(\.)?([А-Я]|[A-Z])\.)?"#, str: newStr)
    var arrayOfRooms = searchByRegularExpresion(regularEx: #"[А-Я]-\d{3,}\s+\d+"#, str: newStr) //?
    
    arrayOfPares = arrayOfPares.map({ (str) in
        str.replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: #"\W+"#, with: "", options: .regularExpression).replacingOccurrences(of: #"\d{1,}"#, with: "", options: .regularExpression)
    })
    
    arrayOfRooms = arrayOfRooms.map { (str) in
        str.replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: #"[А-Я]-\d{3,}\s+"#, with: "", options: .regularExpression)
    }
    
    arrayOfTeachers = arrayOfTeachers.map({ (str) in
        str.replacingOccurrences(of: #"\t+"#, with: "", options: .regularExpression).replacingOccurrences(of: #"\s+"#, with: " ", options: .regularExpression)
    })
    
    arrayOfPareNumbers = arrayOfPareNumbers.map({ (str) in
        str.replacingOccurrences(of: #"\s+[А-Я]"#, with: "", options: .regularExpression)
    })
    
    for (index, _) in arrayOfPareNumbers.enumerated() {
        arrayOfPareNumbers[index] = String(arrayOfPareNumbers[index].last!)
    }
    
    let arrayOfGroups = searchByRegularExpresion(regularEx: #"\b[А-Я]-\d{2,3}\b"#, str: newStr)
    
    print(arrayOfPareNumbers)
    
    
    
    for (index, _) in arrayOfPares.enumerated() {
        arrayOfCurric.append(("\(arrayOfPares[index])",
                            "\(arrayOfTeachers[index])",
                            "\(arrayOfRooms[index])",
                            "\(arrayOfGroups[index])",
                            "\(arrayOfPareNumbers[index])"))
    }
    return arrayOfCurric
}
