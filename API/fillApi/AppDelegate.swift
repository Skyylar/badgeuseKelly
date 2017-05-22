//
//  AppDelegate.swift
//  API
//
//  Created by Gustin TANG on 22/05/2017.
//  Copyright © 2017 Gustin TANG. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        let url = URL(string: "https://prepintra-api.etna-alternance.net/trombi")
        
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }
            else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    
                    var x = 2017
                    
                    while x != 2022 {
                        let test = (json["\(x)"] as! NSArray)
                        
                        for trombi in test {
                            let jsonData = try JSONSerialization.data(withJSONObject: trombi, options: JSONSerialization.WritingOptions.prettyPrinted)
                            var date = try JSONSerialization.jsonObject(with: jsonData, options:.allowFragments) as! [String : AnyObject]
                            
                            // GET WALL NAME
                            //print(date["wall_name"])
                            
                            // GET ID of ALL Student of ONE Promo
                            let ID : Int = date["id"] as! Int
                            let url = URL(string: "https://prepintra-api.etna-alternance.net/trombi/\(ID)")
                            
                            URLSession.shared.dataTask(with: url!, completionHandler: {
                                (alert, response, error) in
                                if(error != nil){
                                    print("error")
                                } else {
                                    do {
                                        let variable = try JSONSerialization.jsonObject(with: alert!, options:.allowFragments) as! [String : AnyObject]
                                        let students = (variable["students"] as! NSArray)
                                        for student in students {
                                            let jsonDate = try JSONSerialization.data(withJSONObject: student, options: JSONSerialization.WritingOptions.prettyPrinted)
                                            var Date = try JSONSerialization.jsonObject(with: jsonDate, options:.allowFragments) as! [String : AnyObject]
                                            
                                            //GET by Search AN USER
                                            let login : String = Date["login"] as! String
                                            let url3 : String = "https://auth.etna-alternance.net/api/users/\(login)"
                                            
                                            let url4 = URL(string: url3)
                                            URLSession.shared.dataTask(with: url4!, completionHandler: {
                                                (data, response, error) in
                                                if(error != nil){
                                                    print("error")
                                                }else{
                                                    do {
                                                        let json2 = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                                                        
                                                        //Complete Loaded User to the API
                                                        let fname = json2["firstname"] as! String
                                                        let lname = json2["lastname"] as! String
                                                        let promo1 = date["wall_name"] as! String
                                                        let promo3 : String = String(promo1.characters.filter { $0 != "'"})
                                                        let promo2 : String = String(promo3.characters.filter { $0 != "-"})
                                                        let promo : String = String(promo2.characters.filter { $0 != " "})
                                                        
                                                        
                                                        if json2["close"] is String {
                                                            let close = true
                                                            let url5 : String = "http://178.62.123.239/badgeuse/api.php?fname=\(fname)&lname=\(lname)&login=\(login)&close=\(close)&promo=\(promo)"
                                                            
                                                            
                                                            if let myURL = NSURL(string: url5) {
                                                                do {
                                                                    let myHTMLString = try NSString(contentsOf: myURL as URL, encoding: String.Encoding.utf8.rawValue)
                                                                    print(myHTMLString)
                                                                } catch {
                                                                    print(error)
                                                                }
                                                            }
                                                            
                                                        }
                                                        else {
                                                            let close = false
                                                            let url5 : String = "http://178.62.123.239/badgeuse/api.php?fname=\(fname)&lname=\(lname)&login=\(login)&close=\(close)&promo=\(promo)"
                                                            
                                                            if let myURL = NSURL(string: url5) {
                                                                do {
                                                                    let myHTMLString = try NSString(contentsOf: myURL as URL, encoding: String.Encoding.utf8.rawValue)
                                                                    print(myHTMLString)
                                                                } catch {
                                                                    print(error)
                                                                }
                                                            }
                                                        }
                                                    } catch let error as NSError{
                                                        print(error)
                                                    }
                                                }
                                            }).resume()
                                        }
                                        
                                    } catch let error as NSError{
                                        print(error)
                                    }
                                }
                            }).resume()
                            
                        }
                        x = x + 1
                    }
                }
                catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

