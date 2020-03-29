//
//  SelfSizedTableView.swift
//  YouTubeList
//
//  Created by Admin on 3/27/20.
//  Copyright © 2020 BadJesus. All rights reserved.
//

import Foundation
import UIKit

class SelfSizedTableView: UITableView {
    var countItem : CGFloat = 0
    var cellHight : CGFloat = UIScreen.main.bounds.size.height
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        setNeedsLayout()
        layoutIfNeeded()
        
        let height = cellHight * countItem
        return CGSize(width: contentSize.width, height: height)
    }
}
