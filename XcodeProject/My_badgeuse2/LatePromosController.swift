//
//  TableViewController.swift
//  My_badgeuse2
//
//  Created by Killian BAILLIF on 20/04/2017.
//  Copyright © 2017 Killian BAILLIF. All rights reserved.
//

import UIKit

struct promosForLate {
    static var choosen: Array<Any> = []
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
        let myURLString = "http://178.62.123.239/badgeuse/api.php?badgeuse=\(bool)&promo=\(promo3)"
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
            
            do {
                let myHTMLString = String(data: data, encoding: String.Encoding.utf8)
                // Implement THE new Code HERE
                print(myHTMLString)
                // END of the Code
                
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()

        /*if let myURL = NSURL(string: myURLString) {
            do {
                let myHTMLString = try NSString(contentsOf: myURL as URL, encoding: String.Encoding.utf8.rawValue)
                var StringRecordedArr = myHTMLString.components(separatedBy: " ")
                var x = 0
                for close in StringRecordedArr {
                    if close == "" {
                        StringRecordedArr.remove(at: x)
                        x = x + 1
                    }
                    else {
                        x = x + 1
                    }
                }
                
                //StringRecordedArr is the FINAL ARRAY
                promosForLate.choosen = StringRecordedArr
                
            } catch {
                print(error)
            }
            self.performSegue(withIdentifier: "showlate", sender: self)
        }
        else {
            print("nope")
        }*/
    }
}
