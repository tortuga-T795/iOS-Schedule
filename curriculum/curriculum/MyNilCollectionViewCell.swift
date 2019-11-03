//
//  MyNilCollectionViewCell.swift
//  curriculum
//
//  Created by IvanLyuhtikov on 10/30/19.
//  Copyright © 2019 IvanLyuhtikov. All rights reserved.
//

import UIKit

class MyNilCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
        self.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
