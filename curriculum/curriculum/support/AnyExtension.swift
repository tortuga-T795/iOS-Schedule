//
//  AnyExtension.swift
//  curriculum
//
//  Created by IvanLyuhtikov on 10/27/19.
//  Copyright © 2019 IvanLyuhtikov. All rights reserved.
//

import UIKit
import AudioToolbox


//MARK: - ViewController Extension

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return final[section].count+1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        collectionView.scrollToItem(at: IndexPath(item: 0, section: currentDay), at: .centeredHorizontally, animated: false)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return final.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellNill = collectionView.dequeueReusableCell(withReuseIdentifier: StringIdentifierCell.nilCell, for: indexPath) as! MyNilCollectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StringIdentifierCell.defCell, for: indexPath) as! MyCell
        let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: StringIdentifierCell.dayCell, for: indexPath) as! DayOfWeekCell
        
        cell.backgroundColor = .lightGray
        cell.layer.cornerRadius = 10
        
        if indexPath.row == 0 {
            dayCell.layer.cornerRadius = 10
            dayCell.label.text = arrayOfDays[indexPath.section]
            return dayCell
        }
        
        if final[indexPath.section][indexPath.row-1] == nil {
            return cellNill
        }
        cell.data = final[indexPath.section][indexPath.row-1]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellNilSize = CGSize(width: collectionView.frame.width-40, height: collectionView.frame.height/25)
        let cellSize = CGSize(width: collectionView.frame.width-40, height: collectionView.frame.height/6)
        let cellWeekSize = CGSize(width: collectionView.frame.width-40, height: collectionView.frame.height/10)
        
        if indexPath.row == 0 {
            return cellWeekSize
        }
        
        if final[indexPath.section][indexPath.row-1] == nil {
            return cellNilSize
        }
        return cellSize
        
        
    }
    
    
    //MARK: - Edge
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if abs(velocity.x) > 0.1 {
            AudioServicesPlaySystemSound(1519)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
//        if indexPath.section == firstWeek.count-1 {
//            print("index")
//        }
        
    }
}


//MARK: - Calendar Extension

extension Calendar {
    func dayOfWeek() -> Int {
        let day = Calendar.current.component(.weekday, from: Date())-2
        return day >= 0 ? day : 6
    }
}

extension String {
  subscript (i: Int) -> Character {
    return self[index(startIndex, offsetBy: i)]
  }
}
