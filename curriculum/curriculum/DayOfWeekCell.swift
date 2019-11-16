//
//  DayOfWeekCell.swift
//  curriculum
//
//  Created by IvanLyuhtikov on 11/3/19.
//  Copyright © 2019 IvanLyuhtikov. All rights reserved.
//

import UIKit

class DayOfWeekCell: UICollectionViewCell {
    
    var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false ///: "AAAAAAA"
        label.textAlignment                             = .center
//        label.backgroundColor                         = .white
        label.textColor                                 = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.layer.masksToBounds                       = true
        label.layer.cornerRadius                        = 10
        label.font = UIFont.boldSystemFont(ofSize: 40)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        contentView.addSubview(label)
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
