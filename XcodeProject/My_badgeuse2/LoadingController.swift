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
    
     override func viewDidAppear(_ animated: Bool) {
            // Do any additional setup after loading the view, typically from a nib.
            self.hideKeyboardWhenTappedAround()
            if (nbconnection.countco != 1) {
                let url = URL(string: "https://prepintra-api.etna-alternance.net/trombi")
                
                URLSession.shared.dataTask(with: url!, completionHandler: {
                    (data, response, error) in
                    if(error != nil){
                        print("error")
                    }
                    else {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                            
                            var x = 2016
                            var wall: Array<Any> = []
                            var id: Array<Int> = []
                            
                            while (x < 2022) {
                                let test = (json["\(x)"] as! NSArray)
                                for trombi in test {
                                    let jsonData = try JSONSerialization.data(withJSONObject: trombi, options: JSONSerialization.WritingOptions.prettyPrinted)
                                    var date = try JSONSerialization.jsonObject(with: jsonData, options:.allowFragments) as! [String : AnyObject]
                                    
                                    // GET WALL NAME
                                    wall.append(date["wall_name"])
                                    // Get ID
                                    id.append(date["id"] as! Int)
                                    
                                }
                                x = x + 1
                            }
                            promoSelected.promotab = wall
                            promoSelected.idpromotab = id
                            self.performSegue(withIdentifier: "LinkStart", sender: self)
                        }
                        catch let error as NSError{
                            print(error)
                        }
                    }
                }).resume()
            }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
