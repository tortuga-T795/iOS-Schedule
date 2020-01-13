//
//  LinkData.swift
//  curriculum
//
//  Created by Тимофей Лукашевич on 11/23/19.
//  Copyright © 2019 IvanLyuhtikov. All rights reserved.
//
import Foundation




let linkDispGroup = DispatchGroup()

func dictionaryRequest () -> [String] {
    
    linkDispGroup.enter()
    guard let url = URL(string: "https://kbp.by/rasp/timetable/view_beta_kbp/?q=") else { return [""] }
    var arrOfData: [String] = []
    
      _ = URLSession.shared.dataTask(with: url) { (data, response, error) in
          guard let data = data else { return }
          
        let htmlContext = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        
         arrOfData = searchByRegularExpresion(regularEx: #"href=\"\?cat=group&amp;id=\d+\">([A-Z,А-Я])?(-)?\d+"#, str: htmlContext ?? "")
        
        linkDispGroup.leave()
      }.resume()
    
    linkDispGroup.wait()
    
    return arrOfData;
}


func getLinkDictionary() -> [String: String] {
 
    let dataArr =  dictionaryRequest()
    
    var linkDictionary: [String: String] = [:]
    for element in dataArr {
        
        let id = element
            .replacingOccurrences(of: #"href=\"\?cat=group&amp;id="#, with: "",  options: .regularExpression)
            .replacingOccurrences(of: #"\">.+"#, with: "",  options: .regularExpression)
        
        let title = element.replacingOccurrences(of: #"href=\"\?cat=group&amp;id=\d+\">"#, with: "",  options: .regularExpression)
        linkDictionary[title] = "https://kbp.by/rasp/timetable/view_beta_kbp/?cat=group&id=" + id

    }

    print(linkDictionary)
    return linkDictionary
}



var links = getLinkDictionary()

var currentLinks = [String: String]()
