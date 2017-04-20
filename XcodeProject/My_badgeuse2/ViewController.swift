//
//  ViewController.swift
//  My_badgeuse2
//
//  Created by Killian BAILLIF on 11/04/2017.
//  Copyright © 2017 Killian BAILLIF. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

struct nbconnection {
    static var countco: Int = 1
}


class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var PickerView: UIPickerView!
    @IBOutlet weak var ButtonSend: UIButton!
    
    @IBOutlet var rwefsdc: UILabel!
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return promoSelected.promotab[row] as! String
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return promoSelected.promotab.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        promoSelected.promotion = promoSelected.promotab[row] as! String
        promoSelected.id = row
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func decoButton(_ sender: Any) {
        nbconnection.countco = 1
        let cookieStore = HTTPCookieStorage.shared
        for cookie in cookieStore.cookies ?? [] {
            print(cookie)
            cookieStore.deleteCookie(cookie)
        }
        self.performSegue(withIdentifier: "LoginView", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (nbconnection.countco == 1) {
            self.performSegue(withIdentifier: "LoginView", sender: self)
        }
  
    }
    
}
