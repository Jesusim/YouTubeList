//
//  CommentCell.swift
//  YouTubeList
//
//  Created by Admin on 3/27/20.
//  Copyright © 2020 BadJesus. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var textUser: UITextView!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
