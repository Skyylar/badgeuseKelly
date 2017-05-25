//
//  CloseComptViewController.swift
//  My_badgeuse2
//
//  Created by Killian BAILLIF on 20/04/2017.
//  Copyright © 2017 Killian BAILLIF. All rights reserved.
//

import UIKit
struct whoAreClosed {
    static var imClose : Array<Any> = []
}

class CloseComptViewController: UIViewController {

    // Search all students who are closed
    override func viewDidLoad() {
        super.viewDidLoad()
        var wall_close: Array<Any> = []
        if (whoAreClosed.imClose.isEmpty) {
            for promo in promoSelected.promotab {
                var promo1 = String((promo as! String).characters.filter {$0 != "-"})
                var promo2 = String(promo1.characters.filter {$0 != " "})
                let promo3 = String(promo2.characters.filter {$0 != "'"})
                let myURLString = "http://178.62.123.239/api/api.php?closecompte=true&promo=\(promo3)"
                let url = URL(string: myURLString)!
                let urlconfig = URLSessionConfiguration.default
                urlconfig.timeoutIntervalForRequest = 5
                urlconfig.timeoutIntervalForResource = 20
                let session = URLSession(configuration : urlconfig, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue.main)
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
                    // THE NEW code HERE
                    let StringRecorded = myHTMLString?.components(separatedBy: " ")
                    var x = 0
                    //GET ALL student in one ARRAY
                    for test in StringRecorded! {
                        if test == "" {
                            x = x + 1
                        }
                        else {
                            wall_close.append(test)
                        }
                    }
                    print(wall_close)
                    whoAreClosed.imClose = wall_close
                    })
                task.resume()
                }
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.performSegue(withIdentifier: "imClose", sender: self)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if !whoAreClosed.imClose.isEmpty {
            self.performSegue(withIdentifier: "imClose", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
