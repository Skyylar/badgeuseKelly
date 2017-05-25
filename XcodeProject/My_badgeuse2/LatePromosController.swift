//
//  TableViewController.swift
//  My_badgeuse2
//
//  Created by Killian BAILLIF on 20/04/2017.
//  Copyright © 2017 Killian BAILLIF. All rights reserved.
//

import UIKit

struct promosForLate {
    static var choosen  : Array<Any> = []
    static var name     : String     = ""
    static var late     : Array<Any> = []
    static var miss     : Array<Any> = []
}

class TableViewController: UITableViewController {
    
    let empty: [String] = ["Not Loaded"]
    var selected = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Set number of labels
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if promoSelected.promotab.isEmpty {
            return empty.count
        }
        else {
            return promoSelected.promotab.count
        }
    }
    
    // Fill labels text with informations
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if (promoSelected.idpromotab.isEmpty) {
            cell.textLabel?.text = self.empty[indexPath.row]
        }
        else {
            cell.textLabel?.text = promoSelected.promotab[indexPath.row] as? String
        }
        return cell
        
    }
    
    // Search people who are late
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let promo = promoSelected.promotab[indexPath.row] as! String
        var promo1 = String(promo.characters.filter {$0 != "-"})
        var promo2 = String(promo1.characters.filter {$0 != " "})
        let promo3 = String(promo2.characters.filter {$0 != "'"})
        
        let bool = false
        let myURLString = "http://178.62.123.239/api/api.php?badgeuse=\(bool)&promo=\(promo3)"
        let url = URL(string: myURLString)!
        
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            let myHTMLString = String(data: data, encoding: String.Encoding.utf8)
            //THE new Code HERE
            var wall_login: Array<Any> = []
            var wall_late: Array<Any> = []
            var wall_missed: Array<Any> = []
            let StringRecordedArr = myHTMLString?.components(separatedBy: " ")
            var x = 0
            //GET ALL student in one ARRAY
            for test in StringRecordedArr! {
                if test == "" {
                    x = x + 1
                }
                else {
                    wall_login.append(test)
                }
            }
            for student in wall_login
            {
                let myURLString2 = "http://178.62.123.239/api/api.php?ls=true&promo=\(promo3)&login=\(student)"
                if let myURL = NSURL(string: myURLString2) {
                    do {
                        let myHTMLString = try NSString(contentsOf: myURL as URL, encoding: String.Encoding.utf8.rawValue)
                        let StringRecordedArr = myHTMLString.components(separatedBy: " ")
                        wall_late.append(StringRecordedArr[0])
                        wall_missed.append(StringRecordedArr[1])
                    } catch {
                        print(error)
                    }
                }
            }
            promosForLate.choosen = wall_login
            promosForLate.name = promo3
            promosForLate.late = wall_late
            promosForLate.miss = wall_missed
        })
        task.resume()
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.performSegue(withIdentifier: "showlate", sender: nil)
        }

    }
}
