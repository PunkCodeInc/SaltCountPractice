//
//  TabBarController.swift
//  SaltCount
//
//  Created by Jeff DeWitte on 11/23/18.
//  Copyright © 2018 Jeff DeWitte. All rights reserved.
//

import UIKit

typealias Completion = () -> Void
protocol TabBarParentDelegate {
    func fetchCounters(completion: Completion?)
    func createCounterFrom(counterDict: NSDictionary, completion: Completion)
    func incrementCounterAt(indexPath: IndexPath)
    func decrementCounterAt(indexPath: IndexPath)
    func updateCounterAt(indexPath: IndexPath,
                         withValues counterDict:NSDictionary,
                         completion: Completion)
    func deleteCounterAt(indexPath: IndexPath, completion: Completion)
    func counterCount() -> Int?
    func counterAt(indexPath: IndexPath) -> Counter?
}

class TabBarController: UITabBarController {

    // MARK: Properties
    
    private let dataController = TabBarDataController()
    
    // MARK: Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        // Do any additional setup after loading the view.
    }
    
    // MARK: Public Methods
    
    func cleanUp() {
        dataController.saveCounterContext()
    }
    
    // MARK: Private Methods
    
    private func setupViewControllers() {
        // Init controllers
        let tableListController = TableListController()
        
        // Configure master controller with delegate(s)
        dataController.configureWith(tableListDelegate: tableListController)
        
        //Init VCs
        let tableListVC = TableListViewController.tableListViewControllerInNC(parentDelegate: self,
                                                                              controller: tableListController)
        
        viewControllers = [tableListVC]
    }
}

extension TabBarController: TabBarParentDelegate {
    
    func fetchCounters(completion: Completion?) {
        dataController.fetchCounters(completion: completion)
    }
    
    func createCounterFrom(counterDict: NSDictionary, completion: Completion) {
        dataController.insert(counterDict: counterDict, completion: completion)
    }
    
    func incrementCounterAt(indexPath: IndexPath) {
        dataController.incrementCounterAt(indexPath: indexPath) { [weak self] in
            self?.dataController.fetchCounters(completion: nil)
        }
    }
    
    func decrementCounterAt(indexPath: IndexPath) {
        dataController.decrementCounterAt(indexPath: indexPath) { [weak self] in
            self?.dataController.fetchCounters(completion: nil)
        }
    }
    
    func updateCounterAt(indexPath: IndexPath,
                         withValues counterDict: NSDictionary,
                         completion: Completion) {
        dataController.updateCounterAt(indexPath: indexPath,
                                       withValues: counterDict,
                                       completion: completion)
    }
    
    func deleteCounterAt(indexPath: IndexPath, completion: Completion) {
        dataController.deleteCounterAt(indexPath: indexPath, completion: completion)
    }
    
    func counterCount() -> Int? {
        return dataController.numberOfCounters()
    }
    
    func counterAt(indexPath: IndexPath) -> Counter? {
        return dataController.retrieveCounterAt(indexPath: indexPath)
    }
    
}

