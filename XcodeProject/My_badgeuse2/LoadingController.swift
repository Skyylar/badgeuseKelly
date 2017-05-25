//
//  LoadingController.swift
//  My_badgeuse2
//
//  Created by Killian BAILLIF on 19/04/2017.
//  Copyright © 2017 Killian BAILLIF. All rights reserved.
//
import UIKit

struct promoSelected {
    static var promotion: String = "2021"
    static var promotab: Array<Any> = []
    static var idpromotab: Array<Any> = []
    static var id: Int = 195
}

class LoadingController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Search all promo on trombi
        self.hideKeyboardWhenTappedAround()
        
        if (nbconnection.countco != 1) {
            if (promoSelected.promotab.isEmpty) {
                let url = URL(string: "https://prepintra-api.etna-alternance.net/trombi")
                URLSession.shared.dataTask(with: url!, completionHandler: {
                    (data, response, error) in
                    if(error != nil){
                        print("error")
                    }
                    else {
                       self.fillAllName(data: data!)
                    }
                }).resume()
            }
        }
        
    }
    
    func fillAllName (data : Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as! [String : AnyObject]
            var x = 2017
            var wall: Array<Any> = []
            var id: Array<Int> = []
            var tmp: String = "t"
            while (x < 2022) {
                let test = (json["\(x)"] as! NSArray)
                for trombi in test {
                    let jsonData = try JSONSerialization.data(withJSONObject: trombi, options: JSONSerialization.WritingOptions.prettyPrinted)
                    var date = try JSONSerialization.jsonObject(with: jsonData, options:.allowFragments) as! [String : AnyObject]
                    let wall_name: String = date["wall_name"] as! String
                    if tmp != wall_name {
                        
                        // GET WALL NAME
                        wall.append(date["wall_name"]!)

                        // Get ID
                        id.append(date["id"] as! Int)
                        tmp = wall_name
                    }
                }
                x = x + 1
            }
            promoSelected.promotab = wall
            promoSelected.idpromotab = id
        }
        catch let error as NSError{
            print(error)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if promoSelected.promotab.isEmpty == false {
            self.performSegue(withIdentifier: "LinkStart", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
