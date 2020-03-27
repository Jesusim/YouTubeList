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
    @IBOutlet weak var chanelName: UILabel!
    @IBOutlet weak var publishedAt: UILabel!
    
    var video : Video?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setElementView()
    }
    
    func setElementView() {
        
        titleVideo.text = video?.snippet.title
        textDescription.text = video?.snippet.description
        chanelName.text = video?.snippet.channelTitle
        publishedAt.text = video?.snippet.publishedAt
        
        DispatchQueue.global().async {
            guard let data = self.video?.snippet.thumbnails?.medium?.getDataByURL() else { return }
            DispatchQueue.main.async {
                self.imageThumbnail.image = UIImage(data: data)
            }
        }
    }
    
    @IBAction func playVideo(_ sender: Any) {
        
        // Loaded video by apple
        let stringUrl = "https://devstreaming-cdn.apple.com/videos/tutorials/TestFlight_App_Store_Connect_2018/hls_vod_mvp.m3u8"
        guard let url = URL(string: stringUrl) else { return }
        
        let player : AVPlayer = AVPlayer(url:url)
        let controller = AVPlayerViewController()
        controller.player = player
        present(controller, animated: true) {
            player.play()
        }
    }
    
}
