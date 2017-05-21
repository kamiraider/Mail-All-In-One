//
//  AddAcountController.swift
//  Mail All In One
//
//  Copyright © 2017 AMProgram. All rights reserved.
//

import UIKit
import RealmSwift
import SafariServices
import SwiftKeychainWrapper

class AddAcountController: UIViewController {

    private let realm = try! Realm()
    
    @IBOutlet weak var errorPrint: UILabel!
    
    @IBAction func add(_ sender: UIButton) {
        errorPrint.isHidden = true
        
        if login.text != "", password.text != "" , (login.text?.hasSuffix("@gmail.com"))! {
            
            if KeychainWrapper.standard.string(forKey: "Login") == nil {
                
                KeychainWrapper.standard.set(login.text!, forKey: "Login")
                KeychainWrapper.standard.set(password.text!, forKey: "Pass")
            } else {
                errorPrint.text = "Аккаунт на данном устройстве уже создан"
                errorPrint.isHidden = false
            }
        } else {
            errorPrint.text = "Не корректные данные почты"
            errorPrint.isHidden = false
        }
    }
    
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func deleteAcount () {
        KeychainWrapper.standard.removeObject(forKey: "Login")
        KeychainWrapper.standard.removeObject(forKey: "Pass")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorPrint.isHidden = true
        if KeychainWrapper.standard.string(forKey: "Login") != nil {
            errorPrint.text = "Аккаунт на данном устройстве уже создан"
            errorPrint.isHidden = false
        }
    }
}

typealias SafariDelegate = AddAcountController

extension SafariDelegate : SFSafariViewControllerDelegate {
    
    // dismiss SFSafariViewController (Done button)
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // present SFSafariViewController modally
    fileprivate func openUrlWithSafariVC(_ urlstring:String) {
        let sfvc = SFSafariViewController(url: URL(string: urlstring)!, entersReaderIfAvailable: true)
        sfvc.delegate = self
        self.present(sfvc, animated: true, completion: nil)
    }
}
 
extension AddAcountController {
    
    private func getToken () {
        // параметры запроса
        let scope = "https://mail.google.com/"
        let access_type = "online"
        let include_granted_scopes = "true"
        let state = "state_parameter_passthrough_value"
        let redirect_uri = "com.googleusercontent.apps.154606389410-9ahkls4ff1rt88omue8r73u7i4otcrtv"
        //let redirect_uri = "http://localhost:8080"
        let response_type = "code"
        let clientID = "154606389410-9ahkls4ff1rt88omue8r73u7i4otcrtv.apps.googleusercontent.com"
        
        
        //let requestURL = "https://accounts.google.com/o/oauth2/auth?scope=" + scope + "&access_type=offline&prompt=consent&redirect_uri=" + uri + "&client_id=" + clientID
        
        let requestURL = "https://accounts.google.com/o/oauth2/v2/auth?scope=" + scope + "&access_type=" + access_type + "&include_granted_scopes" + include_granted_scopes + "&state=" + state + "&redirect_uri=" + redirect_uri + "&response_type=" + response_type + "&client_id=" + clientID
        
        self.openUrlWithSafariVC(requestURL)
        // теперь надо узнать какой именно редирект нужен у меня не верный
    }
}
