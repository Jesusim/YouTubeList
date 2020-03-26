//
//  ViewController.swift
//  YouTubeList
//
//  Created by Admin on 3/25/20.
//  Copyright © 2020 BadJesus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate let network: NetworkService = .shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        network.getList()
        // Do any additional setup after loading the view.
    }


}

