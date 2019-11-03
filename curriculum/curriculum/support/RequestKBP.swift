//
//  RequestKBP.swift
//  curriculum
//
//  Created by IvanLyuhtikov on 10/15/19.
//  Copyright © 2019 IvanLyuhtikov. All rights reserved.
//

import Foundation
import Kanna


class RequestKBP {
    
    static let dispGroup = DispatchGroup()
    
    class func getData(stringURL: String, format arrOfStr: [String], closure: @escaping (Any) -> ()) {
        
        var strOneDay = String()
        
        dispGroup.enter()
        guard let url = URL(string: stringURL) else { return }
        
        _ = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            let htmlContext = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            
            if let doc = try? HTML(html: htmlContext!, encoding: .utf8) {
                
                for one in arrOfStr {
                    strOneDay.removeAll()
                    
                    for link in doc.css(one) {
                        
                        strOneDay.append(link.text ?? "")
                        
                    }
                    closure(strOneDay)
                    
                }
                dispGroup.leave()
            }
            
        }.resume()
        
    }
    
}
