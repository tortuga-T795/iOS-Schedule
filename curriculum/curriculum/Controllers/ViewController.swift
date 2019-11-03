//
//  ViewController.swift
//  curriculum
//
//  Created by IvanLyuhtikov on 10/6/19.
//  Copyright © 2019 IvanLyuhtikov. All rights reserved.
//

import UIKit
import AudioToolbox
import Kanna


typealias CurriculumDay = (pare: String, teacher: String, room: String, group: String)?

let arrayOfDays = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Cуббота"]
let link = "https://kbp.by/rasp/timetable/view_beta_kbp/?cat=group&id=89"
let fontDefault: CGFloat = 17
let fontDayOfWeek: CGFloat = 50



class ViewController: UIViewController {
    
    let nonePareStr = "Пара снята"
    var segment: UISegmentedControl!
    
    var currentDay: Int = {
        return Calendar.current.dayOfWeek()
    }()
    
    
    var indicator: UIActivityIndicatorView!
    
    var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(MyCell.self, forCellWithReuseIdentifier: StringIdentifierCell.defCell)
        cv.register(MyNilCollectionViewCell.self, forCellWithReuseIdentifier: StringIdentifierCell.nilCell)
        cv.register(DayOfWeekCell.self, forCellWithReuseIdentifier: StringIdentifierCell.dayCell)
        return cv
    }()
    

    var secondWeek: [[CurriculumDay]] = [[("Programming", "Molofey1", "418", "T-795"), ("Practic", "Shukalovich", "505", "Т-795"), nil],
                                        [nil, ("Programming", "Molofey2", "418", "T-795")],
                                        [nil, ("English", "Fool", "108", "T-795"), ("Programming", "Molofey3", "418", "T-795"), ("Shukalovich", "KPYAP", "503", "T-795")],
                                        [nil, ("Programming", "Molofey4", "418", "T-795")],
                                        [nil, nil, ("Programming", "Molofey5", "418", "T-795")],
                                        [nil, ("Programming", "Molofey6", "418", "T-795"), nil]]
    
    var final = [[CurriculumDay]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.5810584426, green: 0.1285524964, blue: 0.5745313764, alpha: 1)
        
        setSegmentControl()
        setIcon()
        
        collectionView.isPagingEnabled = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        setCollectionViewConstraints()
        
        setLoading()
        
        
        //MARK: - Work with HTML
        
        var strAll = String()
        
        RequestKBP.getData(stringURL: link,
                           format: ["td[class='number'], div[class='pair lw_1'] ,div[class='pair lw_1 added'], div[class='pair lw_1 week week1'], div[class='pair lw_1 week week2']",
                                    "td[class='number'], div[class='pair lw_2'] ,div[class='pair lw_2 added'], div[class='pair lw_2 week week1'], div[class='pair lw_1 week week2']",
                                    "td[class='number'], div[class='pair lw_3'] ,div[class='pair lw_3 added'], div[class='pair lw_3 week week1'], div[class='pair lw_1 week week2']",
                                    "td[class='number'], div[class='pair lw_4'] ,div[class='pair lw_4 added'], div[class='pair lw_4 week week1'], div[class='pair lw_1 week week2']",
                                    "td[class='number'], div[class='pair lw_5'] ,div[class='pair lw_5 added'], div[class='pair lw_5 week week1'], div[class='pair lw_1 week week2']",
                                    "td[class='number'], div[class='pair lw_6'] ,div[class='pair lw_6 added'], div[class='pair lw_6 week week1'], div[class='pair lw_1 week week2']"
                                    ],
                           closure: {
                            strAll.append($0 as! String)
                            self.final.append(curriculumDayFinal($0 as! String))

        })

        RequestKBP.dispGroup.notify(queue: .main) {
            print("It's end of loading HTML data")
            self.indicator.stopAnimating()
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: self.currentDay), at: .centeredHorizontally, animated: true)
            print(self.final)
        }
        
                
    }
    
    
    //MARK: - Setting funcs
    
    fileprivate func setLoading() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: view.frame.midX-10, y: view.frame.midY-10, width: 20, height: 20))
        collectionView.addSubview(indicator)
        indicator.startAnimating()
    }
    
    fileprivate func setCollectionViewConstraints() {
        collectionView.backgroundColor = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    fileprivate func setSegmentControl() {
        segment = UISegmentedControl(items: ["Сейчас", "Следующая"])
        segment.addTarget(self, action: #selector(segmentChange), for: .valueChanged)
        segment.selectedSegmentIndex = 0
        segment.frame.size = CGSize(width: view.frame.width/2, height: view.frame.height/17)
        segment.center = CGPoint(x: view.frame.midX, y: segment.frame.height/2+40)
        view.addSubview(segment)
    }
    
    @objc fileprivate func segmentChange() {
        self.collectionView.reloadData()
    }
    
    
    fileprivate func setIcon() {
        let imageV = UIImageView(image: #imageLiteral(resourceName: "kbp"))
        imageV.contentMode = .scaleAspectFit
        navigationItem.titleView = imageV
    }
    
    

    override func viewSafeAreaInsetsDidChange() {
        print("safe area")
    }
    
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        print(currentDay)
        collectionView.scrollToItem(at: IndexPath(item: 0, section: currentDay), at: .centeredHorizontally, animated: true)
    }
    

}
