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
    @IBOutlet weak var errorLog: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.clear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.clear()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func unwindAll (_ : UIStoryboardSegue) {
    
    }
    
    @IBAction func connection(_ sender: Any) {
        let userLogin: String = inputLogin.text!
        let userPass:  String = inputPassword.text!
        if (userLogin.isEmpty || userPass.isEmpty)
        {
            self.missingFields()
            return
        }
        let json = self.initJson(login: userLogin, pass: userPass)
        let url = URL(string: "https://auth.etna-alternance.net/identity")!
        let session = self.initSession()
        let request = self.initRequest(url: url, json: json)
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            self.passThrowEtnaApi(data: data, json: json)
        })
        task.resume()
    }
    
    func passThrowEtnaApi (data : Data, json : Dictionary<String, String>) {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                if (json.count != 0) {
                    // Check if the user have an accompte on etna
                    let login : String = json["login"] as! String
                    let url = URL(string: "https://auth.etna-alternance.net/api/users/\(login)")
                    URLSession.shared.dataTask(with: url!, completionHandler: {
                        (alert, response, error) in
                        if(error != nil){
                            print("error")
                            self.messageError(message : "Server error")
                        } else {
                            self.welcomeAdm(data: data)
                        }
                    }).resume()
                }
                else {
                    self.messageError(message : self.errorLog.text!)
                }
            }
            else {
                self.messageError(message : "Internal error")
            }
        } catch let error {
            print(error.localizedDescription)
            self.messageError(message: "Internal error")
        }
    }
    
    func welcomeAdm (data : Data) {
        do {
            // Try the group of the user
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: AnyObject],
                let groups = (json["groups"] as? NSArray) {
                let student: String = "student"
                for group in groups {
                    if ((group as! String).caseInsensitiveCompare(student) == ComparisonResult.orderedSame) {
                        nbconnection.countco = 2
                        self.performSegue(withIdentifier: "MainPage", sender: self)
                    }
                }
                print(nbconnection.countco)
                if (nbconnection.countco == 1) {
                    self.messageError(message: "Vous n'êtes pas autorisés")
                }
            }
            else {
                self.messageError(message : "Internal error")
            }
        }catch let error as NSError{
            print(error)
            self.messageError(message : "Internal error")
        }

    }
    
    func initRequest (url : URL, json : Dictionary<String, String>) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
            self.messageError(message: "Internal error")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    func initSession () -> URLSession {
        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 5
        urlconfig.timeoutIntervalForResource = 20
        let session = URLSession(configuration : urlconfig, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue.main)
        return session
    }
    
    func initJson (login : String, pass : String) -> Dictionary<String, String> {
        let json = ["login": login, "password": pass]
        self.inputLogin.text = ""
        self.inputPassword.text = ""
        return json
    }
    
    func missingFields () {
        let alertController = UIAlertController(title: "Alert", message: "Veuillez remplir tous les champs", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func messageError(message : String) {
        self.errorLog.text = message
        self.errorLog.isHidden = !self.errorLog.isHidden
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.errorLog.isHidden = !self.errorLog.isHidden
        }
    }
    
    func clear() {
        let cookieStore = HTTPCookieStorage.shared
        for cookie in cookieStore.cookies ?? [] {
            print(cookie)
            cookieStore.deleteCookie(cookie)
        }
    }
}
