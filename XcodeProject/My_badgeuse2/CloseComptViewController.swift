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
                let myURLString = "http://178.62.123.239/api.php?closecompte=true&promo=\(promo3)"
                if let myURL = NSURL(string: myURLString) {
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
                        //GET ALL student in one ARRAY
                        for test in StringRecordedArr {
                            wall_close.append(test)
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            whoAreClosed.imClose = wall_close
            self.performSegue(withIdentifier: "imClose", sender: self)
            
        }
        else {
            self.performSegue(withIdentifier: "imClose", sender: self)
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
