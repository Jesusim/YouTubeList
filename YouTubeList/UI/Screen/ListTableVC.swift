//
//  ListTableVC.swift
//  YouTubeList
//
//  Created by Admin on 3/26/20.
//  Copyright © 2020 BadJesus. All rights reserved.
//

import UIKit

class ListTableVC: UITableViewController, UISearchBarDelegate {
    
    fileprivate let network: NetworkService = .shared
    let refreshView = UIRefreshControl()
    
    lazy private var activityIndicator : UIActivityIndicatorView = {
        let rect = CGRect(x: 0, y: 0, width: 50, height: 50)
        return UIActivityIndicatorView(frame: rect)
    }()
    
    var list = [Video]()
    private var nextPageToken : String = ""
    private var searchText : String = ""
    private var total : Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = StringResource.titleList
        setSearchVC()
        setRefresher()
    }
    
    private func setSearchVC() {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = StringResource.searchPlaceholder
        searchController.searchBar.setValue(StringResource.сancel, forKey: "cancelButtonText")
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    private func setRefresher() {
        refreshView.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl = refreshView
    }
    
    @objc func refresh() {
        searchText = ""
        nextPageToken = ""
        list.removeAll()
        tableView.reloadData()
        refreshView.endRefreshing()
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! VideoCell

        cell.title.text = list[indexPath.row].snippet.title
        cell.descriptionVideo.text = list[indexPath.row].snippet.description
        
        DispatchQueue.global().async {
            guard let data = self.list[indexPath.row].snippet.thumbnails?.medium?.getDataByURL() else { return }
            DispatchQueue.main.async {
                cell.imageThumbnail.image = UIImage(data: data)
            }
        }
  
        return cell
    }
    
    // MARK: - Pagination
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let currentTotal = total else { return }
        if indexPath.row == list.count - 1 && currentTotal >= list.count && list.count >= 20  {
            loadList(searchText: searchText)
        }
    }
    
    // MARK: - Search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text?.replacingOccurrences(of: " ", with: "+") else { return }
        loadList(searchText: searchText)
    }
    
    private func loadList(searchText : String) {
        
        addActivityIndicator()
        
        network.searchVideo(searchText: searchText, nextPageToken: self.nextPageToken) { (response , error) in
            
            if let currentError = error {
                
                ErrorService.shared.setError(viewController: self, titelError: StringResource.error, messageError: currentError.localizedDescription)
                
            } else {

                guard let currentResponse = response else { return }
                self.setResponseElment(response: currentResponse, searchText: searchText)

            }
            
            self.removeActivityIndicator()
            self.tableView.reloadData()
            
        }
        
    }
    
    private func setResponseElment(response : YouTubeList, searchText : String) {
        if let item = response.items {
            setItem(item: item, searchElement: self.searchText == searchText)
            nextPageToken = response.nextPageToken ?? ""
            total = response.pageInfo?.totalResults
            self.searchText = searchText
        } else {
            ErrorService.shared.setError(viewController: self, titelError: StringResource.error, messageError: StringResource.error)
        }
    }
    
    private func setItem(item : [Video], searchElement: Bool) {
        if searchElement {
            self.list += item
        } else {
            self.list = item
        }
    }
    
    private func addActivityIndicator() {
        activityIndicator.color = .red
        activityIndicator.startAnimating()
        tableView.backgroundView = activityIndicator
    }
    
    private func removeActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    // MARK: prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
        let detailVC = segue.destination as? DetailVC
        detailVC?.video = list[indexPath.row]
    }
    
}
