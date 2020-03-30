//
//  DetailVC.swift
//  YouTubeList
//
//  Created by Admin on 3/26/20.
//  Copyright © 2020 BadJesus. All rights reserved.
//

import UIKit
import AVKit

class DetailVC: UIViewController, SetIndicator {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet weak var titleVideo: UILabel!
    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var textDescription: UITextView!
    @IBOutlet weak var chanelName: UILabel!
    @IBOutlet weak var publishedAt: UILabel!
    @IBOutlet weak var commentTableView: SelfSizedTableView!
    @IBOutlet weak var scrollViewDetail: UIScrollView!
    
    fileprivate let network: NetworkService = .shared
    
    var video : Video?
    fileprivate var listComment = [Comment]()
    
    private var nextPageCommentToken : String = ""
    private var switchLoadNewCooment = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setElementView()
    }
    
    func setElementView() {
        
        titleVideo.text = video?.snippet.title
        textDescription.text = video?.snippet.description
        chanelName.text = video?.snippet.channelTitle
        publishedAt.text = video?.snippet.publishedAt
        
        scrollViewDetail.delegate = self
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
        
        guard let url = self.video?.snippet.thumbnails?.medium?.url else { return }
        getImageByURl(url: url) { (image) in
            self.imageThumbnail.image = image
        }
        
        loadComments()
    }
    
    func loadComments() {
        
        switchLoadNewCooment = false
        addActivityIndicator(tableView: commentTableView)
        
        network.getComments(videoId: (video?.id?.videoId)!, nextPageToken: nextPageCommentToken) { (item, error) in
            
            self.removeActivityIndicator()
            if error != nil {
                
                ErrorService.shared.setError(viewController: self, titelError: StringResource.error, messageError: error?.localizedDescription)
                
            } else {
                
                guard
                    let response = item,
                    let currentItem = response.items
                    else { return }
                self.setCooments(currentItem)
                
                guard let pageToken = response.nextPageToken else { return }
                self.nextPageCommentToken = pageToken
                
            }
            
        }
        
    }
    
    func setCooments(_ currentItem : [Comment]) {
        
        listComment += currentItem
        
        DispatchQueue.main.async {
            self.commentTableView.reloadData()
            self.switchLoadNewCooment = true
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        
        if distanceFromBottom < height && switchLoadNewCooment && nextPageCommentToken != "" {
            loadComments()
        }
    }
    
    @IBAction func playVideo(_ sender: Any) {
        
        // Used pre-loaded video by apple because usage youtube framework forbidden by specification.
        // https://developers.google.com/youtube/iframe_api_reference
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BaseTableViewCell
        
        cell.titleBaseLable.text = listComment[indexPath.row].snippet?.topLevelComment?.snippet?.authorDisplayName
        cell.textBaseView.text = listComment[indexPath.row].snippet?.topLevelComment?.snippet?.textDisplay
        cell.backgroundColor = .clear
        
        guard let url = listComment[indexPath.row].snippet?.topLevelComment?.snippet?.authorProfileImageUrl else { return cell }
        getImageByURl(url: url) { (image) in
            cell.imageBaseView.image = image
            cell.imageBaseView.layer.cornerRadius = cell.imageBaseView.bounds.width / 2
        }
        commentTableView.cellHight = cell.frame.height
        return cell
    }
    
}

