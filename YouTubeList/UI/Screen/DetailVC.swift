//
//  DetailVC.swift
//  YouTubeList
//
//  Created by Admin on 3/26/20.
//  Copyright © 2020 BadJesus. All rights reserved.
//

import UIKit
import AVKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var titleVideo: UILabel!
    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var textDescription: UITextView!
    
    var video : Video?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setElementView()
    }
    
    func setElementView() {
        
        titleVideo.text = video?.snippet.title
        textDescription.text = video?.snippet.description
        
        guard let urlImage = video?.snippet.thumbnails.medium?.url else { return }
        
        HelpService.shared.dowloadImageAndSetIt(stringUrl: urlImage) { (image) in
            self.imageThumbnail.image = image
        }
        
    }

}
