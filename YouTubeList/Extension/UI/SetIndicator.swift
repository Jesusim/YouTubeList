//
//  SetIndicator.swift
//  YouTubeList
//
//  Created by Admin on 3/30/20.
//  Copyright © 2020 BadJesus. All rights reserved.
//

import Foundation
import UIKit

protocol SetIndicator {
    var activityIndicator : UIActivityIndicatorView { get set}
    func addActivityIndicator(tableView: UITableView)
    func removeActivityIndicator()
}

extension SetIndicator {

    var activityIndicator : UIActivityIndicatorView {
        let rect = CGRect(x: 0, y: 0, width: 50, height: 50)
        return UIActivityIndicatorView(frame: rect)
    }

    func addActivityIndicator(tableView: UITableView) {
        activityIndicator.color = .red
        activityIndicator.startAnimating()
        tableView.backgroundView = activityIndicator
    }

    func removeActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }

}
