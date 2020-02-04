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
        return final[section].count
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return final.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StringIdentifierCell.defCell, for: indexPath) as! MyCell
        cell.backgroundColor = .lightGray
        cell.layer.cornerRadius = 10
        
        cell.data = final[indexPath.section][indexPath.row]
        return cell
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSize = CGSize(width: collectionView.frame.width-20, height: collectionView.frame.height/8)
        
        return cellSize
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    //MARK: - Edge
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if abs(velocity.x) > 0.1 {
            AudioServicesPlaySystemSound(1519)
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        weekSegment.selectedSegmentIndex = indexPath.section
//        customWeek.selectedIndex = indexPath.section
//
//    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.width
//        weekSegment.selectedSegmentIndex = Int(pageNumber)
        customWeek.selectedIndex = Int(pageNumber)
    }
    
    
}

//MARK: - SearchBar Extension

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
//        print(viewConroller)
        let text = searchBar.text ?? ""
        var mutStr = NSMutableAttributedString(string: text)
        mutStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(red: 1, green: 0.2301670313, blue: 0.1861662865, alpha: 1)], range: NSRange(location: 0, length: 1))
        
        self.viewController?.lableGroup.attributedText = mutStr
//        searchBar.text = text
        
        link = links[text] ?? ""
        
        if link == "" {
            searchBar.text = "Даун, такой группы нету!"
            mutStr = NSMutableAttributedString(string: defaults.string(forKey: "defGroup")!)
            mutStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(red: 1, green: 0.2301670313, blue: 0.1861662865, alpha: 1)], range: NSRange(location: 0, length: 1))
            self.viewController?.lableGroup.attributedText = mutStr
            return
        }
        
        if #available(iOS 13.0, *) {
            dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                defaults.set(link, forKey: "defLink")
                defaults.set(self.viewController?.lableGroup.text, forKey: "defGroup")
                self.viewController?.final = []
                day = 0
                self.viewController?.loadDataForWeek()
            }
        } else {
            defaults.set(link, forKey: "defLink")
            defaults.set(self.viewController?.lableGroup.text, forKey: "defGroup")
            self.viewController?.final = []
            day = 0
            self.viewController?.loadDataForWeek()
            navigationController?.popViewController(animated: true)
        }

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            //Check Connection
            
            currentLinks = links
            tableView.reloadData()
            return
        }
        currentLinks = links.filter({ (one) -> Bool in
            return one.key.contains(searchText)
        })
        tableView.reloadData()
    }
    
}

//MARK: - SearchViewController Extension

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentLinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableCell", for: indexPath)
        let array = Array(currentLinks.keys).sorted { (str1, str2) -> Bool in return str1 < str2 }
        cell.textLabel?.text = Array(array)[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = tableView.cellForRow(at: indexPath)?.textLabel?.text
        
        let mutStr = NSMutableAttributedString(string: text ?? "")
        mutStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(red: 1, green: 0.2301670313, blue: 0.1861662865, alpha: 1)], range: NSRange(location: 0, length: 1))
        
        self.viewController?.lableGroup.attributedText = mutStr
        searchBar.text = text
        
        link = links[text!] ?? ""
        
        if #available(iOS 13.0, *) {
            dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                defaults.set(link, forKey: "defLink")
                defaults.set(self.viewController?.lableGroup.text, forKey: "defGroup")
                self.viewController?.final = []
                
                day = 0
                self.viewController?.loadDataForWeek()
            }
        } else {
            defaults.set(link, forKey: "defLink")
            defaults.set(self.viewController?.lableGroup.text, forKey: "defGroup")
            self.viewController?.final = []
            day = 0
            self.viewController?.loadDataForWeek()
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    
}


extension UIView {
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: SearchVC.SEARCH_WIDTH, height: SearchVC.SEARCH_HEIGHT)
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
}


//MARK: - Calendar Extension

extension Calendar {
    func dayOfWeek() -> Int {
        let day = Calendar.current.component(.weekday, from: Date())-2
        return day >= 0 ? day : 0
    }
}

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}


//MARK: - Custom Extension

extension ViewController: CustomWeekBarDelegate {
    func countOf() -> Int {
        return 6
    }
    
    func namesOf() -> [String] {
        ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб"]
    }
    
    
}
