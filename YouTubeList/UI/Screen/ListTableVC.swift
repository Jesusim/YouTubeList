//
//  ListTableVC.swift
//  YouTubeList
//
//  Created by Admin on 3/26/20.
//  Copyright © 2020 BadJesus. All rights reserved.
//

import UIKit

class ListTableVC: UITableViewController {
    
    fileprivate let network: NetworkService = .shared
    var list = [Video]()
    var nextPageToken : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = StringResource.titleList
        loadList(pageToken: nextPageToken)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return list.count
    }
    
    func loadList(pageToken: String) {
        
        network.getList(pageToken : pageToken) { (response, error) in
            
            if let currentError = error {
                HelpService.shared.setError(viewController: self, titelError: StringResource.error, messageError: currentError.localizedDescription)
            } else {
                guard let currentResponse = response else { return }
                self.list += currentResponse.items
                self.nextPageToken = currentResponse.nextPageToken
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! VideoCell

        cell.title.text = list[indexPath.row].snippet.title
        cell.descriptionVideo.text = list[indexPath.row].snippet.description
        guard let thumbnailsUrlString =  list[indexPath.row].snippet.thumbnails.standard?.url else { return  cell}
        HelpService.shared.dowloadImageAndSetIt(stringUrl: thumbnailsUrlString) { (image) in
            cell.imageThumbnail.image = image
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
        let detailVC = segue.destination as? DetailVC
        detailVC?.video = list[indexPath.row]
    }

}
