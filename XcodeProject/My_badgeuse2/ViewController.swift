//
//  ViewController.swift
//  My_badgeuse2
//
//  Created by Killian BAILLIF on 11/04/2017.
//  Copyright © 2017 Killian BAILLIF. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // Fucntions to dismiss keyvboard on tap
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
    
    // Set number of columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Set labels of pickerview
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return promoSelected.promotab[row] as? String
    }
    
    // Set number of labels
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return promoSelected.promotab.count
    }
    
    // Give the selected choice
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        promoSelected.promotion = promoSelected.promotab[row] as! String
        promoSelected.id = row
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Buton to deconnect
    @IBAction func decoButton(_ sender: Any) {
        print("oui")
        nbconnection.countco = 1
        // Clear cokies stored axt connection
        let cookieStore = HTTPCookieStorage.shared
        for cookie in cookieStore.cookies ?? [] {
            print(cookie)
            cookieStore.deleteCookie(cookie)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (nbconnection.countco == 1) {
            self.performSegue(withIdentifier: "LoginView", sender: self)
        }
  
    }
    
}
