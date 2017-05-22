//
//  ClosecomptController.swift
//  My_badgeuse2
//
//  Created by Killian BAILLIF on 20/04/2017.
//  Copyright © 2017 Killian BAILLIF. All rights reserved.
//


import UIKit

class CloseComptController: UITableViewController {

    let empty: [String] = ["No one closed"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Set number of labels
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if whoAreClosed.imClose.isEmpty {
            return empty.count
        }
        else {
            return whoAreClosed.imClose.count
        }
    }
    
    // Fil labels with informations
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if (whoAreClosed.imClose.isEmpty) {
            cell.textLabel?.text = self.empty[indexPath.row]
        }
        else {
            cell.textLabel?.text = whoAreClosed.imClose[indexPath.row] as? String
        }
        return cell
    }
    
}
