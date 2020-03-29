//
//  DetailVC.swift
//  YouTubeList
//
//  Created by Admin on 3/26/20.
//  Copyright © 2020 BadJesus. All rights reserved.
//

import UIKit
import AVKit

class DetailVC: UIViewController, LoadImage {
    
    @IBOutlet weak var titleVideo: UILabel!
    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var textDescription: UITextView!
    @IBOutlet weak var chanelName: UILabel!
    @IBOutlet weak var publishedAt: UILabel!
    @IBOutlet weak var commentTableView: SelfSizedTableView!
    
    fileprivate let network: NetworkService = .shared
    
    var video : Video?
    var listComment = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setElementView()
    }
    
    func setElementView() {
        
        titleVideo.text = video?.snippet.title
        textDescription.text = video?.snippet.description
        chanelName.text = video?.snippet.channelTitle
        publishedAt.text = video?.snippet.publishedAt
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
        
        guard let url = self.video?.snippet.thumbnails?.medium?.url else { return }
        getImageByURl(url: url) { (image) in
            self.imageThumbnail.image = image
        }
        
        loadComments()
    }
    
    func loadComments() {
        
        network.getComments(videoId: (video?.id?.videoId)!, nextPageToken: "") { (item, error) in
            
            guard
                let response = item,
                let currentItem = response.items
            else { return }
            
            self.listComment = currentItem
            
            DispatchQueue.main.async {
                self.commentTableView.reloadData()
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

extension DetailVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        commentTableView.countItem = CGFloat(listComment.count)
        return listComment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CommentCell
        
        cell.nameUser.text = listComment[indexPath.row].snippet?.topLevelComment?.snippet?.authorDisplayName
        cell.textUser.text = listComment[indexPath.row].snippet?.topLevelComment?.snippet?.textDisplay
        
        guard let url = listComment[indexPath.row].snippet?.topLevelComment?.snippet?.authorProfileImageUrl else { return cell }
        getImageByURl(url: url) { (image) in
            cell.imageUser.image = image
            cell.imageUser.layer.cornerRadius = cell.imageUser.bounds.width / 2
        }
        commentTableView.cellHight = cell.frame.height
        return cell
    }
    
}

