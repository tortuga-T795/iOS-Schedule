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

typealias CurriculumDay = (pare: String, teacher: String, room: String, group: String, numberPare: String)?

let CONSTANT_WIDTH = UIScreen.main.bounds.width
let CONSTANT_HEIGHT = UIScreen.main.bounds.height

let CONSTANT_COEF_SIZE = CONSTANT_HEIGHT/5

let arrayOfDays = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Cуббота"]
let timePare = [["  8³⁰-\n10⁰⁰", "10¹⁰-\n11⁴⁰", "12¹⁰-\n13⁴⁰", "14⁰⁰-\n15³⁰", "15⁴⁰-\n17¹⁰", "17²⁰-\n18⁵⁰", "19⁰⁰-\n20³⁰"],
                ["  8³⁰-\n10⁰⁰", "10¹⁰-\n11⁴⁰", "11⁵⁰-\n13²⁰", "13⁴⁰-\n15¹⁰", "15²⁰-\n16⁵⁰", "17⁰⁰-\n18³⁰", "18⁴⁰-\n20¹⁰"]]

let defaults = UserDefaults.standard

var link = defaults.string(forKey: "defLink") ?? "https://kbp.by/rasp/timetable/view_beta_kbp/?cat=group&id=31"
let fontDefault: CGFloat = 17
let fontDayOfWeek: CGFloat = 50
var switcherWeek = "lw"
var numOfWeek = 0
var currentGroup = defaults.string(forKey: "defGroup") ?? "Т795"






class ViewController: UIViewController {
    
    var lableGroup: UILabel = {
        let label: UILabel = UILabel()
        
        label.frame.size = CGSize(width: CONSTANT_WIDTH/2, height: 50)
        label.center = CGPoint(x: CONSTANT_WIDTH/2, y: CONSTANT_HEIGHT/15)
        label.textAlignment = .center
        label.font = UIFont(name: Fonts.dreamcast, size: 40)
        label.textColor = #colorLiteral(red: 0.942771256, green: 0.9090159535, blue: 0.8918639421, alpha: 1)
        let mutStr = NSMutableAttributedString(string: currentGroup)
        mutStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(red: 1, green: 0.2301670313, blue: 0.1861662865, alpha: 1)], range: NSRange(location: 0, length: 1))
        label.attributedText = mutStr
        return label
    }()
    
    
    
    
    var searchButton : UIButton = {
        let button = UIButton()
        
        button.frame.size = CGSize(width: CONSTANT_WIDTH/7, height: CONSTANT_WIDTH/7)
        button.center = CGPoint(x: CONSTANT_WIDTH * 0.9, y: CONSTANT_HEIGHT/15)
        button.setTitle("🔍", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont(name: Fonts.dreamcast, size: 40)
        button.addTarget(self, action: #selector(openSearch), for: .touchUpInside)
        
        return button
    }()
    
    
    
    @objc func openSearch() ->() {
        let searchController = SearchViewController()
        searchController.viewController = self
        
        present(searchController, animated: true, completion: nil)
        
        print("I AM FUCKIG BUTTON")
    }
    
    var weekSegment: UISegmentedControl!
    
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
        cv.register(DayOfWeekCell.self, forCellWithReuseIdentifier: StringIdentifierCell.dayCell)
        return cv
    }()
    
    var final = [[CurriculumDay]]()
    
    //MARK: DetectNumOfWeek
    func detectNumOfWeek() {
        var arr: [String] = []
        
        
        RequestKBP.getData(stringURL: link,
                           format: ["p[class='today'] "], closure: {
                            arr.append($0 as! String)
                   })

        RequestKBP.dispGroup.notify(queue: .main) {
            if self.segment.selectedSegmentIndex == 0 {
                numOfWeek = arr[0].contains("первая неделяОзнакомление") ? 1 : 2
            }
            print(arr[0])
            print(numOfWeek)
            print(switcherWeek)
            print(self.segment.selectedSegmentIndex)
        }

       RequestKBP.dispGroup.wait()
    }
    
    //MARK: LoadWeek
    func loadDataForWeek() {
            self.indicator.startAnimating()
        
            RequestKBP.dispGroup.wait()
        
            RequestKBP.dispGroup.notify(queue: .main) { [weak self] in
                
                guard let self = self else { return }
                
                
                UIApplication.shared.beginIgnoringInteractionEvents()
                
                
                //MARK: - Work with HTML
                
                var strAll = String()
            
                RequestKBP.getData(stringURL: link,
                                   format: ["td[class='number'], div[class='pair \(switcherWeek)_1'] ,div[class='pair \(switcherWeek)_1 added'], div[class='pair \(switcherWeek)_1 week week\(numOfWeek)']",
                                            "td[class='number'], div[class='pair \(switcherWeek)_2'] ,div[class='pair \(switcherWeek)_2 added'], div[class='pair \(switcherWeek)_2 week week\(numOfWeek)']",
                                            "td[class='number'], div[class='pair \(switcherWeek)_3'] ,div[class='pair \(switcherWeek)_3 added'], div[class='pair \(switcherWeek)_3 week week\(numOfWeek)']",
                                            "td[class='number'], div[class='pair \(switcherWeek)_4'] ,div[class='pair \(switcherWeek)_4 added'], div[class='pair \(switcherWeek)_4 week week\(numOfWeek)']",
                                            "td[class='number'], div[class='pair \(switcherWeek)_5'] ,div[class='pair \(switcherWeek)_5 added'], div[class='pair \(switcherWeek)_5 week week\(numOfWeek)']",
                                            "td[class='number'], div[class='pair \(switcherWeek)_6'] ,div[class='pair \(switcherWeek)_6 added'], div[class='pair \(switcherWeek)_6 week week\(numOfWeek)']"
                                            ],
                                   closure: { [weak self] in
                                    
                                    guard let self = self else { return }
                                    
                                    strAll.append($0 as! String)
                                    self.final.append(curriculumDayFinal($0 as! String))
      
                })

                RequestKBP.dispGroup.notify(queue: .main) { [weak self] in
                    
                    guard let self = self else { return }
                    
                    print("It's end of loading HTML data")
                    self.indicator.stopAnimating()
                    self.collectionView.reloadData()
                    self.collectionView.scrollToItem(at: IndexPath(item: 0, section: self.currentDay), at: .centeredHorizontally, animated: false)
                    
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.indicator.stopAnimating()
//                    print(self.final)
                }
            }
        }
    
    override func loadView() {
        
        super.loadView()
        detectNumOfWeek()
    }
    
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        self.view.backgroundColor = #colorLiteral(red: 0.0953803435, green: 0.08950889856, blue: 0.1199778244, alpha: 1)
        
        view.addSubview(lableGroup)
        view.addSubview(searchButton)
        
        setCollectionView() //Collection with constraits and all
        
        setWeekSegment()
        
        self.setLoading()
        self.setSegmentControl()
        
//        self.setIcon()
        
        loadDataForWeek()
         
        
      if !self.final.allSatisfy({$0.isEmpty}) {
            
            let l = UILabel(frame: CGRect.init(x: CONSTANT_WIDTH * 0.2, y: CONSTANT_HEIGHT * 0.35 , width: 300, height: 100))
            print(">>>>>>>its WORK")
            l.text = "нет подключения к серверу"
            l.textColor = .black

            self.view.addSubview(l)
        }
       
       
    }
    
    
    //MARK: - Setting funcs
    
    fileprivate func setWeekSegment() {
        
        weekSegment = UISegmentedControl(items: ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб"])
        weekSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white,
                                            NSAttributedString.Key.font : UIFont(name: "Dreamcast", size: 32) as Any],
                                           for: .normal)
        
        weekSegment.backgroundColor = #colorLiteral(red: 0.09532604367, green: 0.0894042179, blue: 0.1199849471, alpha: 1)
        weekSegment.tintColor = .systemRed
        if #available(iOS 13.0, *) {
            weekSegment.selectedSegmentTintColor = .systemRed
            weekSegment.selectedSegmentIndex = currentDay
        }
        
        weekSegment.frame = CGRect(x: 0, y: view.frame.height-65, width: view.frame.width, height: 65)
        weekSegment.addTarget(self, action: #selector(weekSegmentChanged), for: .valueChanged)
        view.addSubview(weekSegment)
    }
    
    @objc func weekSegmentChanged() {
        collectionView.scrollToItem(at: IndexPath(item: 0, section: weekSegment.selectedSegmentIndex), at: .centeredHorizontally, animated: false)
    }
    
    
    fileprivate func setCollectionView() {
        
        self.collectionView.isPagingEnabled = true
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.view.addSubview(self.collectionView)
        self.setCollectionViewConstraints()
    }
    
    fileprivate func setLoading() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: view.frame.midX-10, y: view.frame.midY-10, width: 20, height: 20))
        indicator.color = #colorLiteral(red: 0.7436106205, green: 0.1554034054, blue: 0.07575485855, alpha: 1)
        collectionView.addSubview(indicator)
        indicator.startAnimating()
    }
    
    fileprivate func setCollectionViewConstraints() {
        collectionView.backgroundColor = #colorLiteral(red: 0.9518175721, green: 0.9089502096, blue: 0.870041728, alpha: 1)
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: CONSTANT_COEF_SIZE).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    fileprivate func setSegmentControl() {
        let font = UIFont.systemFont(ofSize: 16)
        
        segment = UISegmentedControl(items: ["Сейчас", "Следующая"])
        segment.addTarget(self, action: #selector(segmentChange), for: .valueChanged)
        segment.selectedSegmentIndex = 0
        segment.backgroundColor = #colorLiteral(red: 0.1899176538, green: 0.1831629872, blue: 0.2396201789, alpha: 1)
        segment.tintColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        segment.frame.size = CGSize(width: view.frame.width / 1.7, height: view.frame.height/13)
        segment.center = CGPoint(x: view.frame.midX, y: segment.frame.height * 2)
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : font], for: .normal)
        if #available(iOS 13.0, *) {
            segment.selectedSegmentTintColor = #colorLiteral(red: 0.3566326499, green: 0.4438212514, blue: 0.5379906893, alpha: 1)
        }
        view.addSubview(segment)
    }
    
    @objc fileprivate func segmentChange() {
        
        indicator.startAnimating()
        
        switcherWeek = switcherWeek == "rw" ? "lw" : "rw"
        numOfWeek = numOfWeek == 1 ? 2 : 1
        day = 0
        print("segmentChanged")
        print(numOfWeek)
        print(switcherWeek)
        print(segment.selectedSegmentIndex)
        var copyFinal = [[CurriculumDay]]()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
       
        RequestKBP.getData(stringURL: link,
                           format: ["td[class='number'], div[class='pair \(switcherWeek)_1'] ,div[class='pair \(switcherWeek)_1 added'], div[class='pair \(switcherWeek)_1 week week\(numOfWeek)']",
                                    "td[class='number'], div[class='pair \(switcherWeek)_2'] ,div[class='pair \(switcherWeek)_2 added'], div[class='pair \(switcherWeek)_2 week week\(numOfWeek)']",
                                    "td[class='number'], div[class='pair \(switcherWeek)_3'] ,div[class='pair \(switcherWeek)_3 added'], div[class='pair \(switcherWeek)_3 week week\(numOfWeek)']",
                                    "td[class='number'], div[class='pair \(switcherWeek)_4'] ,div[class='pair \(switcherWeek)_4 added'], div[class='pair \(switcherWeek)_4 week week\(numOfWeek)']",
                                    "td[class='number'], div[class='pair \(switcherWeek)_5'] ,div[class='pair \(switcherWeek)_5 added'], div[class='pair \(switcherWeek)_5 week week\(numOfWeek)']",
                                    "td[class='number'], div[class='pair \(switcherWeek)_6'] ,div[class='pair \(switcherWeek)_6 added'], div[class='pair \(switcherWeek)_6 week week\(numOfWeek)']"
                                    ],
                           closure: {
//                            strAll.append($0 as! String)
                            copyFinal.append(curriculumDayFinal($0 as! String))
        })
        
        
        RequestKBP.dispGroup.notify(queue: .main) { [weak self] in
            
            guard let self = self else { return }
            
            
            self.final = copyFinal
            self.collectionView.reloadData()
            
            if self.segment.selectedSegmentIndex == 1 {
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
            } else {
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: self.currentDay), at: .centeredHorizontally, animated: false)
            }
            UIApplication.shared.endIgnoringInteractionEvents()
            
            self.indicator.stopAnimating()
        }
        
        copyFinal = []
    }
    
    
    fileprivate func setIcon() {
        let imageV = UIImageView(image: #imageLiteral(resourceName: "kbp"))
        imageV.contentMode = .scaleAspectFit
        navigationItem.titleView = imageV
    }
    
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        AudioServicesPlaySystemSound(1521)
        collectionView.scrollToItem(at: IndexPath(item: 0, section: currentDay), at: .centeredHorizontally, animated: false)
    }
    

}
