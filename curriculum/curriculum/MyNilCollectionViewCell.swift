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
        
        backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        self.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
