//
//  AnswerCommentTableVC.swift
//  YouTubeList
//
//  Created by Admin on 3/30/20.
//  Copyright © 2020 BadJesus. All rights reserved.
//

import UIKit

class AnswerCommentTableVC: UITableViewController, SetIndicator {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    fileprivate let network: NetworkService = .shared
    var parentId : String?
    private var nextAswerCommentsPageToken : String = ""
    fileprivate var listAnswerComment = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = StringResource.titelAnswerComment
        loadAswerComments()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listAnswerComment.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BaseTableViewCell
        
        cell.titleBaseLable.text = listAnswerComment[indexPath.row].snippet?.authorDisplayName
        cell.textBaseView.text = listAnswerComment[indexPath.row].snippet?.textDisplay
        
        guard let url = listAnswerComment[indexPath.row].snippet?.authorProfileImageUrl else { return cell }
        getImageByURl(url: url) { (image) in
            cell.imageBaseView.image = image
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == listAnswerComment.count - 1 && listAnswerComment.count >= 50 && nextAswerCommentsPageToken != "" {
            loadAswerComments()
        }
    }
    
    
    func loadAswerComments() {
        
        guard let id = parentId else { return }
        addActivityIndicator(tableView: tableView)
        
        network.getAnswersComment(parentId: id, nextPageToken: nextAswerCommentsPageToken) { (response, error) in
            
            if error != nil {
                
                ErrorService.shared.setError(viewController: self, titelError: StringResource.error, messageError: error?.localizedDescription)
                
            } else {
                
                guard
                    let currentResponse = response,
                    let currentItem = currentResponse.items
                    else { return }
                self.setAnswer(currentItem : currentItem)
                
                guard let nextPage = currentResponse.nextPageToken else { return }
                self.nextAswerCommentsPageToken = nextPage
            }
            
        }
        
    }
    
    func setAnswer(currentItem : [Comment]) {
        listAnswerComment += currentItem
        removeActivityIndicator()
        tableView.reloadData()
    }
    
}
