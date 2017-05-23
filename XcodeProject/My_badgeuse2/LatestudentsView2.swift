//
//  TableView2.swift
//  My_badgeuse2
//
//  Created by Killian BAILLIF on 20/04/2017.
//  Copyright © 2017 Killian BAILLIF. All rights reserved.
//


import UIKit

class TableView2Controller: UITableViewController {

    let empty: [String] = ["Error while loading file"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Set number of labels
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if promosForLate.choosen.isEmpty {
            return empty.count
        }
        else {
            return promosForLate.choosen.count
        }
    }
    
    // Fill labels with informations
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if (promosForLate.choosen.isEmpty) {
            cell.textLabel?.text = self.empty[indexPath.row]
        }
        else {
            cell.textLabel?.text = promosForLate.choosen[indexPath.row] as? String
        }
        return cell
    }

}
