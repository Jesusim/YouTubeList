//
//  BaseTableViewCell.swift
//  YouTubeList
//
//  Created by Admin on 3/30/20.
//  Copyright © 2020 BadJesus. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    @IBOutlet weak var textBaseView: UITextView!
    @IBOutlet weak var titleBaseLable: UILabel!
    @IBOutlet weak var imageBaseView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
