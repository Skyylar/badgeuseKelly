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
    
    @IBAction func sendCSV(_ sender: Any) {
        let myURLString = "http://178.62.123.239/api/api.php?send=true&promo=\(promosForLate.name)"
        let url = URL(string: myURLString)!
        let session = self.initSession()
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            _ = String(data: data, encoding: String.Encoding.utf8)
            self.csvAlert()
        })
        task.resume()
    }

    // Set number of labels
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if promosForLate.choosen.isEmpty {
            return empty.count
        }
        else {
            return promosForLate.choosen.count - 1
        }
    }
    
    // Fill labels with informations
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? LatestViewCell  else {
            fatalError("The dequeued cell is not an instance of LatestViewCell.")
        }
        if (promosForLate.choosen.isEmpty) {
            cell.loginLabel.text = self.empty[indexPath.row]
        }
        else {
            cell.loginLabel.text = promosForLate.choosen[indexPath.row] as? String
            cell.lateLabel.text = promosForLate.late[indexPath.row] as? String
            cell.absentLabel.text = promosForLate.miss[indexPath.row] as? String
        }
        return cell
    }
    
    func csvAlert() {
        let alertController = UIAlertController(title: "Alert", message: "CSV envoyé", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func initSession () -> URLSession {
        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 5
        urlconfig.timeoutIntervalForResource = 20
        let session = URLSession(configuration : urlconfig, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue.main)
        return session
    }
}
