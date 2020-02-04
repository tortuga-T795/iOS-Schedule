//
//  SearchViewController.swift
//  curriculum
//
//  Created by IvanLyuhtikov on 11/23/19.
//  Copyright © 2019 IvanLyuhtikov. All rights reserved.
//

import UIKit
import AudioToolbox

class SearchViewController: UIViewController {
    
    var searchBar: UISearchBar!
    var gradient: CAGradientLayer!
    weak var viewController: ViewController?
    
    lazy var tableView: UITableView = {
        let tv: UITableView
        
        if #available(iOS 13.0, *) {
            tv = UITableView(frame: CGRect(x: 0,
                                           y: 65,
                                           width: SearchVC.SEARCH_WIDTH,
                                           height: SearchVC.SEARCH_HEIGHT-65))
            tv.layer.cornerRadius = 15
        } else {
            tv = UITableView(frame: CGRect(x: 20,
                                           y: (navigationController?.navigationBar.bounds.height)!+95,
                                           width: UIScreen.main.bounds.width-40,
                                           height: SearchVC.SEARCH_HEIGHT))
            tv.layer.cornerRadius = 10
        }
        tv.register(MyTableCell.self, forCellReuseIdentifier: "MyTableCell")
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    
//    override func viewDidLayoutSubviews() {
//        self.view.layer.frame = self.view.layer.frame.insetBy(dx: 30, dy: 30);
//        self.view.layer.cornerRadius = 15
//    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        currentLinks = links
        
        modalPresentationStyle = .pageSheet
        
        modalTransitionStyle = .flipHorizontal
        view.alpha = 0.95
        
        settingTableView()
        
        if #available(iOS 13.0, *) {
            searchBar = UISearchBar(frame: CGRect(x: 0, y: 15, width: view.frame.width-40, height: 50))
            searchBar.tintColor = #colorLiteral(red: 0.7436106205, green: 0.1554034054, blue: 0.07575485855, alpha: 1)
            searchBar.barTintColor = #colorLiteral(red: 0.7436106205, green: 0.1554034054, blue: 0.07575485855, alpha: 1)
            searchBar.placeholder = "Введите группу"
        } else {
            searchBar = UISearchBar(frame: CGRect(x: 0,
                                                  y: (navigationController?.navigationBar.bounds.height)!+20,
                                                  width: view.frame.width,
                                                  height: 50))
            searchBar.tintColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            searchBar.barTintColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            searchBar.placeholder = "Обнови iOS, дурик)"
        }
        
        
        searchBar.delegate = self
        
        view.addSubview(searchBar)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
        
        if #available(iOS 13.0, *) {
            self.view.layer.frame = SearchVC.FRAME
            view.backgroundColor = #colorLiteral(red: 0.7436106205, green: 0.1554034054, blue: 0.07575485855, alpha: 1)
            self.view.layer.cornerRadius = 15
        } else {
            view.backgroundColor = #colorLiteral(red: 0.1383914351, green: 0.1330786645, blue: 0.1663919389, alpha: 1)
            
        }

//        view.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.lightGrey)
        
        searchBar.becomeFirstResponder()
        AudioServicesPlaySystemSound(1520)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        
    }
    
    fileprivate func settingTableView() {
        view.addSubview(tableView)
    }
    
    deinit {
        print("searchViewController die")
    }

}


