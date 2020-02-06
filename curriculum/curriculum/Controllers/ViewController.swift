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
import Reachability
import RealmSwift

typealias CurriculumDay = (pare: String, teacher: String, room: String, group: String, numberPare: String)?

let CONSTANT_WIDTH = UIScreen.main.bounds.width
let CONSTANT_HEIGHT = UIScreen.main.bounds.height


let CONSTANT_COEF_SIZE = CONSTANT_HEIGHT/5

let arrayOfDays = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Cуббота"]
let timePare = [["  8³⁰-\n10⁰⁰", "10¹⁰-\n11⁴⁰", "12¹⁰-\n13⁴⁰", "14⁰⁰-\n15³⁰", "15⁴⁰-\n17¹⁰", "17²⁰-\n18⁵⁰", "19⁰⁰-\n20³⁰"],
                ["  8³⁰-\n10⁰⁰", "10¹⁰-\n11⁴⁰", "11⁵⁰-\n13²⁰", "13⁴⁰-\n15¹⁰", "15²⁰-\n16⁵⁰", "17⁰⁰-\n18³⁰", "18⁴⁰-\n20¹⁰"]]

let defaults = UserDefaults.standard

var link = defaults.string(forKey: "defLink") ?? links["Т-795"] ?? ""
let fontDefault: CGFloat = 17
let fontDayOfWeek: CGFloat = 50
var switcherWeek = "lw"
var numOfWeek = 0

var switcherWeek2 = "rw"
var numOfWeek2 = 0

var currentGroup = defaults.string(forKey: "defGroup") ?? "Т795"

//variable for checking connection
var reachability = Reachability()!



class ViewController: UIViewController {
    
    //offline load
    var finalElements: Results<Day>!
//    var finalElements2: Results<Day>!
    
    var customWeek: CustomWeekBar!
    
    var final = [[CurriculumDay]]()
    var betaFinal: [[[CurriculumDay]]] = [[],[]]
    
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
    
    
    
    @objc func openSearch() -> () {
        
        if reachability.connection == .none {
            let alert = UIAlertController(title: "Обнаружен Даун", message: "Экономист, wifi вруби", preferredStyle: .alert)
            let action = UIAlertAction(title: "ок я даун", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            AudioServicesPlaySystemSound(1519)
            return
        }
        
        let searchController = SearchViewController()
        searchController.viewController = self
        
        if #available(iOS 13.0, *) {
            present(searchController, animated: true, completion: nil)
        } else {
            navigationController?.pushViewController(searchController, animated: true)
        }
    }
    
    let nonePareStr = "Пара снята"
    var segment: UISegmentedControl!
    //replacement of segment
    var switcher: WeekSwitcher!
    
    
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
    
    
    //MARK: DetectNumOfWeek
    func detectNumOfWeek() {
        var arr: [String] = []
        
        
        RequestKBP.getData(stringURL: link,
                           format: ["p[class='today'] "], closure: {
                            arr.append($0 as! String)
                   })

        RequestKBP.dispGroup.notify(queue: .main) {
            print("loadView")
            
            numOfWeek = arr[0].contains("первая неделяОзнакомление") ? 1 : 2
            
        }

       RequestKBP.dispGroup.wait()
    }
    
    //MARK: - LoadWeek
    func loadDataForWeek() {
        
        let realm = try! Realm()
        let elements = self.finalElements
        
        try! realm.write {
            realm.delete(elements!)
        }
        
        print("loadDataForWeek")
        
        self.indicator.startAnimating()
    
        RequestKBP.dispGroup.wait()
    
        RequestKBP.dispGroup.notify(queue: .main) { [weak self] in
            
            guard let self = self else { return }
            
            UIApplication.shared.beginIgnoringInteractionEvents()
                
                
            //MARK: - Work with HTML
            
            var arrOfDay = [Day]()
            
            numOfWeek2 = numOfWeek == 1 ? 2 : 1
            
            
            var counter = 0
            self.betaFinal = [[],[]]
            
            var strAll = String()
            RequestKBP.getData(stringURL: link,
                               format: ["td[class='number'], div[class='pair \(switcherWeek)_1'] ,div[class='pair \(switcherWeek)_1 added'], div[class='pair \(switcherWeek)_1 week week\(numOfWeek)']",
                                        "td[class='number'], div[class='pair \(switcherWeek)_2'] ,div[class='pair \(switcherWeek)_2 added'], div[class='pair \(switcherWeek)_2 week week\(numOfWeek)']",
                                        "td[class='number'], div[class='pair \(switcherWeek)_3'] ,div[class='pair \(switcherWeek)_3 added'], div[class='pair \(switcherWeek)_3 week week\(numOfWeek)']",
                                        "td[class='number'], div[class='pair \(switcherWeek)_4'] ,div[class='pair \(switcherWeek)_4 added'], div[class='pair \(switcherWeek)_4 week week\(numOfWeek)']",
                                        "td[class='number'], div[class='pair \(switcherWeek)_5'] ,div[class='pair \(switcherWeek)_5 added'], div[class='pair \(switcherWeek)_5 week week\(numOfWeek)']",
                                        "td[class='number'], div[class='pair \(switcherWeek)_6'] ,div[class='pair \(switcherWeek)_6 added'], div[class='pair \(switcherWeek)_6 week week\(numOfWeek)']",
                                "td[class='number'], div[class='pair \(switcherWeek2)_1'] ,div[class='pair \(switcherWeek2)_1 added'], div[class='pair \(switcherWeek2)_1 week week\(numOfWeek2)']",
                                "td[class='number'], div[class='pair \(switcherWeek2)_2'] ,div[class='pair \(switcherWeek2)_2 added'], div[class='pair \(switcherWeek2)_2 week week\(numOfWeek2)']",
                                "td[class='number'], div[class='pair \(switcherWeek2)_3'] ,div[class='pair \(switcherWeek2)_3 added'], div[class='pair \(switcherWeek2)_3 week week\(numOfWeek2)']",
                                "td[class='number'], div[class='pair \(switcherWeek2)_4'] ,div[class='pair \(switcherWeek2)_4 added'], div[class='pair \(switcherWeek2)_4 week week\(numOfWeek2)']",
                                "td[class='number'], div[class='pair \(switcherWeek2)_5'] ,div[class='pair \(switcherWeek2)_5 added'], div[class='pair \(switcherWeek2)_5 week week\(numOfWeek2)']",
                                "td[class='number'], div[class='pair \(switcherWeek2)_6'] ,div[class='pair \(switcherWeek2)_6 added'], div[class='pair \(switcherWeek2)_6 week week\(numOfWeek2)']"
                                        ],
                               closure: { [weak self] in
                                
                                guard let self = self else { return }
                                
                                strAll.append($0 as! String)
                                
                                
                                let currucDay = curriculumDayFinal($0 as! String)
                                
                                if counter <= 5 {
                                    self.betaFinal[0].append(currucDay)
                                } else {
                                    self.betaFinal[1].append(currucDay)
                                }
                                
                                let arrOfElements = Day()
                                
                                for i in currucDay {
                                    let one = Element()
                                    one.teacher = i?.teacher ?? ""
                                    one.pare = i?.pare ?? ""
                                    one.group = i?.group ?? ""
                                    one.room = i?.room ?? ""
                                    one.numberPare = i?.numberPare ?? ""
                                    arrOfElements.storage.append(one)
                                }
                                arrOfDay.append(arrOfElements)
                                counter += 1
            })
            
            RequestKBP.dispGroup.notify(queue: .main) { [weak self] in
                    
                guard let self = self else { return }
                
                
                let realm = try! Realm()


                try! realm.write {
                    realm.add(arrOfDay)
                }
                
                
                print("It's end of loading HTML data")
                
                
                if self.switcher.active == .first {
                    self.final = self.betaFinal[0]
                } else {
                    self.final = self.betaFinal[1]
                }
                
                self.indicator.stopAnimating()
                self.collectionView.reloadData()
                //WARNING
                print(self.currentDay)
                
                if self.switcher.active == .first {
                    self.collectionView.scrollToItem(at: IndexPath(item: 0, section: self.currentDay), at: .centeredHorizontally, animated: false)
                    self.customWeek.selectedButton(sender: nil, index: self.currentDay)
                } else {
                    self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
                    self.customWeek.selectedButton(sender: nil, index: 0)
                }
                
                
                
                UIApplication.shared.endIgnoringInteractionEvents()
                self.indicator.stopAnimating()
//                    print(self.final)
            }
        }
    }
    
    override func loadView() {

        super.loadView()

        if reachability.connection == .none {
            print("You have not connection to internet!")
            return
        }
        detectNumOfWeek()
    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        self.view.backgroundColor = #colorLiteral(red: 0.0953803435, green: 0.08950889856, blue: 0.1199778244, alpha: 1)
        
        view.addSubview(lableGroup)
        view.addSubview(searchButton)
        
        setCollectionView() //Collection with constraits and all
        
        setSwitcher()
        
        setCustomWeek()
        
        self.setLoading()
        
        discribeConnectionNotification()
//        checkConnection()
        
        checkConnectionViewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    
    //MARK: - Setting funcs
    
    fileprivate func checkConnectionViewDidLoad() {
        
        let realm = try! Realm()
        finalElements = realm.objects(Day.self)
        
        print("final")
        
        for (index, day) in finalElements.enumerated() {
            let i = index > 5 ? 1 : 0
            var arrOfCurricDay = [CurriculumDay]()
            for pare in day.getMultyArr() {
                let curricDay = (pare[0], pare[1], pare[2], pare[3], pare[4])
                arrOfCurricDay.append(curricDay)
            }
            betaFinal[i].append(arrOfCurricDay)
        }
        
        if switcher.active == .first {
            final = betaFinal[0]
        } else {
            final = betaFinal[1]
        }
        
        if reachability.connection == .none {
            print(betaFinal[0])
            if betaFinal[0].isEmpty {
                let alert = UIAlertController(title: "Внимание", message: "Для первого запуска приложения необходимо наличие интернета!", preferredStyle: .alert)
                let action = UIAlertAction(title: "ок", style: .default) { _ in
                    exit(0);
                }
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                AudioServicesPlaySystemSound(1519)
            }
            
            let alertInfo = UIAlertController(title: "Помните", message: "В данный момент ваше приложение находится в оффлайн режиме, поэтому текущие данные могут не соответствовать настоящим", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "ок", style: .default, handler: nil)
            alertInfo.addAction(action)
            present(alertInfo, animated: true, completion: nil)
            
            return
        }
        final = []
    }
    
    
    fileprivate func checkConnection() {
        
        if reachability.connection == .none {
            print("You have no internet!")
            DispatchQueue.main.async {
                self.view.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            }
        } else {
            print("You have internet")
            DispatchQueue.main.async {
                self.view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            }
        }
    }
    
    fileprivate func discribeConnectionNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(internetChanged(note:)),
                                               name: Notification.Name.reachabilityChanged,
                                               object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("Could not start notifier")
        }
    }
    
    @objc func internetChanged(note: Notification) {
        let reachability = note.object as! Reachability
        if reachability.connection == .none {
            DispatchQueue.main.async {
                self.view.backgroundColor = #colorLiteral(red: 0.2855577221, green: 0.2712289171, blue: 0.3622636918, alpha: 1)
            }
        } else {
            
            detectNumOfWeek()
            loadDataForWeek()
            
            if reachability.connection == .wifi {
                DispatchQueue.main.async {
                    self.view.backgroundColor = #colorLiteral(red: 0.0953803435, green: 0.08950889856, blue: 0.1199778244, alpha: 1)
                }
            } else {
                DispatchQueue.main.async {
                    self.view.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                }
            }
        }
    }
    
    fileprivate func setSwitcher() {
        switcher = WeekSwitcher(frame: CGRect(x: CONSTANT_WIDTH/2-(view.frame.width/1.4)/2, y: CONSTANT_HEIGHT/15 + 25, width: view.frame.width / 1.4, height: view.frame.height/12))
        switcher.backgroundColor = #colorLiteral(red: 0.1383914351, green: 0.1330786645, blue: 0.1663919389, alpha: 1)
        switcher.active = ActivePosition(rawValue: defaults.integer(forKey: "switcher")) ?? .first
        for i in switcher.buttons {
            i.addTarget(self, action: #selector(segmentChange), for: .touchUpInside)
        }
        view.addSubview(switcher)
    }
    
    fileprivate func setCustomWeek() {
        customWeek = CustomWeekBar(frame: CGRect(x: 0, y: CONSTANT_HEIGHT-CONSTANT_HEIGHT/10, width: CONSTANT_WIDTH, height: CONSTANT_HEIGHT/10))
        customWeek.delegate = self
        customWeek.VC = self
        customWeek.subsribeButtons { [weak self] butt in
            butt.addTarget(self, action: #selector(self?.weekSegmentChanged), for: .touchUpInside)
        }
        
        if reachability.connection == .none {
            customWeek.selectedIndex = 0
        }
        
        view.addSubview(customWeek)
    }
    
    @objc func weekSegmentChanged(sender: UIButton) {
        //WARNING
        collectionView.scrollToItem(at: IndexPath(item: 0, section: sender.tag), at: .centeredHorizontally, animated: false)
        customWeek.selectedButton(sender: nil, index: sender.tag)
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
        
        if reachability.connection == .none {
            indicator.stopAnimating()
        }
    }
    
    fileprivate func setCollectionViewConstraints() {
        collectionView.backgroundColor = #colorLiteral(red: 0.9518175721, green: 0.9089502096, blue: 0.870041728, alpha: 1)
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: CONSTANT_COEF_SIZE).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    @objc fileprivate func segmentChange(sender: UIButton) {
        
        let tuple: (sender: UIButton, active: ActivePosition, reach: Reachability.Connection) = (sender, switcher.active, reachability.connection)
        
        switch tuple {
//        case let (_, _, reach) where reach == .none && betaFinal[0].isEmpty:
//            let alert = UIAlertController(title: "Обнаружен Даун", message: "Экономист, wifi вруби", preferredStyle: .alert)
//            let action = UIAlertAction(title: "ок я даун", style: .default, handler: nil)
//            alert.addAction(action)
//            present(alert, animated: true, completion: nil)
//            AudioServicesPlaySystemSound(1519)
//
//            return
        case let (butt, active, _) where active == .first && butt.tag == 0 || active == .second && butt.tag == 1:
            return
        default:
            break
        }
        
        switcher.active = switcher.active == .first ? .second : .first
        
        if switcher.active == .first {
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: self.currentDay), at: .centeredHorizontally, animated: false)
            self.customWeek.selectedButton(sender: nil, index: self.currentDay)
            final = betaFinal[0]
            defaults.set(0, forKey: "switcher")
        } else {
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
            self.customWeek.selectedButton(sender: nil, index: 0)
            final = betaFinal[1]
            defaults.set(1, forKey: "switcher")
        }
        
        
        collectionView.reloadData()
        
        
    }
    
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        AudioServicesPlaySystemSound(1521)
        //WARNING
        collectionView.scrollToItem(at: IndexPath(item: 0, section: currentDay), at: .centeredHorizontally, animated: false)
        self.customWeek.selectedButton(sender: nil, index: self.currentDay)
    }
    

}
