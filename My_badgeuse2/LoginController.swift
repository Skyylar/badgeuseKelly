//
//  LoginController.swift
//  My_badgeuse2
//
//  Created by Killian BAILLIF on 12/04/2017.
//  Copyright © 2017 Killian BAILLIF. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
   
    @IBOutlet weak var inputLogin: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    
   
        
    override func viewDidLoad() {
        super.viewDidLoad()
        var string2 = "few -few-ffewfwesdc fwe"
        var string3 = String(string2.characters.filter {$0 != " "})
        print(String(string3.characters.filter {$0 != "-"}))
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func connection(_ sender: Any) {
        let userLogin: String = inputLogin.text!
        let userPass:  String = inputPassword.text!
        
        if (userLogin.isEmpty || userPass.isEmpty)
        {
        
            // display alert on empty field
            
            let alertController = UIAlertController(title: "Alert", message: "All fields required", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
    
        let json = ["login": userLogin, "password": userPass]
        
        //create the url with URL
        let url = URL(string: "https://auth.etna-alternance.net/identity")!
        
        //create the session object
        let session = URLSession.shared
        
                
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
             /*   if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let test = json["groups"] as? [[String: Any]] {
                    print(json)
                    for groups in test {
                        print(groups)
                    }
                }*/
                
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    if (json.count != 0) {
                        
                        let login : String = json["login"] as! String
                        let url = URL(string: "https://auth.etna-alternance.net/api/users/\(login)")
                        URLSession.shared.dataTask(with: url!, completionHandler: {
                            (alert, response, error) in
                            if(error != nil){
                                print("error")
                            }else{
                                do{
                                    
                                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: AnyObject],
                                        let groups = (json["groups"] as? NSArray) {
                                        let student: String = "student"
                                        for group in groups {
                                            if ((group as! String).caseInsensitiveCompare(student) == ComparisonResult.orderedSame) {
                                                self.performSegue(withIdentifier: "MainPage", sender: self)
                                                nbconnection.countco = 2
                                                
                                            }
                                        }
                                    }
                                   /* let variable = try JSONSerialization.jsonObject(with: alert!, options:.allowFragments) as! [String : AnyObject]
                                    
                                    
                                    let test = (variable["roles"] as! NSArray)[0] as! String
                                    let student: String = "student"
                                    print(test)
                                    if test == student {
                                        print(json)
                                    }
                                    else {
                                        print("ERROR")
                                    }
                                        */
                                    
                                }catch let error as NSError{
                                    print(error)
                                }
                            }
                        }).resume()
                    }
                }

                
                
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }

}
