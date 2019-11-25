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
        let tv = UITableView(frame: CGRect(x: 0, y: 65, width: SearchVC.SEARCH_WIDTH, height: SearchVC.SEARCH_HEIGHT-65))
        tv.layer.cornerRadius = 15
        tv.register(MyTableCell.self, forCellReuseIdentifier: "MyTableCell")
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        currentLinks = links
        
        modalPresentationStyle = .pageSheet
        
        modalTransitionStyle = .flipHorizontal
        view.alpha = 0.95
        
        settingTableView()
        
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 15, width: view.frame.width-40, height: 50))
        searchBar.tintColor = #colorLiteral(red: 0.7436106205, green: 0.1554034054, blue: 0.07575485855, alpha: 1)
        searchBar.barTintColor = #colorLiteral(red: 0.7436106205, green: 0.1554034054, blue: 0.07575485855, alpha: 1)
        searchBar.placeholder = "Введите группу"
        searchBar.delegate = self
        
        view.addSubview(searchBar)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        
        self.view.layer.frame = SearchVC.FRAME
        view.backgroundColor = #colorLiteral(red: 0.7436106205, green: 0.1554034054, blue: 0.07575485855, alpha: 1)
//        view.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.lightGrey)
        self.view.layer.cornerRadius = 15
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


