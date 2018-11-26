//
//  TableListViewController.swift
//  SaltCount
//
//  Created by Jeff DeWitte on 11/22/18.
//  Copyright © 2018 Jeff DeWitte. All rights reserved.
//

import UIKit

typealias CounterCompletion = (Counter) -> Void
let tableListVCNibName = "TableListViewController"

protocol TableListUpdateDelegate {
    func beginUpdates()
    func endUpdates()
    func insertAt(indexPath: IndexPath?)
    func deleteAt(indexPath: IndexPath?)
    func updateAt(indexPath: IndexPath?)
}

class TableListViewController: UIViewController {

    // MARK: Properties
    
    fileprivate let controller: TableListController
    private let parentDelegate: TabBarParentDelegate
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var countersTableView: UITableView!
    // MARK: Initialization
    
    static func tableListViewControllerInNC(parentDelegate: TabBarParentDelegate, controller: TableListController)
        -> UINavigationController {
            let vc = TableListViewController(controller: controller, parentDelegate: parentDelegate)
            let nc = UINavigationController(rootViewController: vc)
            return nc
    }
    
    init(controller: TableListController,
         parentDelegate: TabBarParentDelegate) {
        self.controller = controller
        self.parentDelegate = parentDelegate
        super.init(nibName: tableListVCNibName, bundle: nil)
        self.controller.configureWith(tableUpdateDelegate: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        activityIndicator.startAnimating()
        parentDelegate.fetchCounters() { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: Private Functions
    
    private func setupUI() {
        title = "Counters"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addButtonPressed(_:)))
        setupTable()
    }
    
    private func setupTable() {
        countersTableView.register(CounterTableViewCell.nib,
                                   forCellReuseIdentifier: CounterTableViewCell.identifier)
        countersTableView.allowsSelection = false
        countersTableView.tableHeaderView = UIView()
        countersTableView.tableFooterView = UIView()
    }
    
    @objc private func addButtonPressed(_ sender: UIBarButtonItem) {
        let addOrEditVC = AddOrEditCounterViewController.addEditViewControllerInNC(parentDelegate: parentDelegate)
        
        present(addOrEditVC, animated: true)
    }
}

extension TableListViewController: TableListUpdateDelegate {
    func beginUpdates() {
        DispatchQueue.main.async { [weak self ] in
            self?.countersTableView.beginUpdates()
        }
    }
    
    func endUpdates() {
        DispatchQueue.main.async { [weak self ] in
            self?.countersTableView.endUpdates()
        }
    }
    
    func insertAt(indexPath: IndexPath?) {
        DispatchQueue.main.async { [weak self ] in
            if let insertIndexPath = indexPath {
                self?.countersTableView.insertRows(at: [insertIndexPath], with: .fade)
            }
        }
    }
    
    func deleteAt(indexPath: IndexPath?) {
        DispatchQueue.main.async { [weak self ] in
            if let deleteindexPath = indexPath {
                self?.countersTableView.deleteRows(at: [deleteindexPath], with: .fade)
            }
        }
    }
    
    func updateAt(indexPath: IndexPath?) {
        DispatchQueue.main.async { [weak self ] in
            if let updateIndexPath = indexPath, let cell = self?.countersTableView.cellForRow(at: updateIndexPath) as? CounterTableViewCell {
                self?.configureCell(cell, at: updateIndexPath)
            }
        }
    }
}

extension TableListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension TableListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parentDelegate.counterCount() ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CounterTableViewCell.identifier) as? CounterTableViewCell else {
            return UITableViewCell()
        }
        configureCell(cell, at: indexPath)
        return cell
    }
    
    
    func configureCell(_ cell: CounterTableViewCell, at indexPath: IndexPath) {
        if let counter = parentDelegate.counterAt(indexPath: indexPath) {
            cell.configureWith(counter: counter)
        }
    }
}


