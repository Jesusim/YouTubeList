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

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = StringResource.titleList
        loadList()
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
    
    func loadList() {
        
        network.getList { (response, error) in
            
            if let currentError = error {
                ErrorService.setError(viewController: self, titelError: StringResource.error, messageError: currentError.localizedDescription)
            } else {
                guard let currentResponse = response else { return }
                self.list = currentResponse.items
                print(self.list)
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
        dowloadImageAndSetIt(cell: cell, stringUrl:  thumbnailsUrlString)

        return cell
    }
    
    func dowloadImageAndSetIt(cell : VideoCell, stringUrl : String) {
        
        DispatchQueue.global().async {
            
            guard
                let url = URL(string: stringUrl),
                let data = try? Data(contentsOf: url)
            else { return }
            
            DispatchQueue.main.async {
                
                cell.imageThumbnail.image = UIImage(data: data)
                
            }
            
        }
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
