//
//  VideoCell.swift
//  YouTubeList
//
//  Created by Admin on 3/26/20.
//  Copyright © 2020 BadJesus. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {

    @IBOutlet weak var descriptionVideo: UITextView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageThumbnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
