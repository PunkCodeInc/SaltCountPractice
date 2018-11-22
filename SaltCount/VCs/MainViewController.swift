//
//  MainViewController.swift
//  SaltCount
//
//  Created by Jeff DeWitte on 11/22/18.
//  Copyright © 2018 Jeff DeWitte. All rights reserved.
//

import UIKit

let mainVCNibName = "MainViewController"

class MainViewController: UIViewController {

    // MARK: Properties
    
    private let mainController: MainController
    
    // MARK: Initialization
    
    static func mainViewControllerInNC(withData dataStore: DataStore)
        -> UINavigationController {
            let controller = MainController(dataStore: dataStore)
            let vc = MainViewController(nibName: mainVCNibName,
                                        bundle: nil,
                                        controller: controller)
            let nc = UINavigationController(rootViewController: vc)
            return nc
    }
    
    init(nibName nibNameOrNil: String?,
         bundle nibBundleOrNil: Bundle?,
         controller: MainController) {
        mainController = controller
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}
