//
//  AddAcountController.swift
//  Mail All In One
//
//  Copyright © 2017 AMProgram. All rights reserved.
//

import UIKit
import RealmSwift

class AddAcountController: UIViewController {

    private let realmLogins = RealmLogins()
    private let realm = try! Realm()
    
    @IBOutlet weak var errorPrint: UILabel!
    
    @IBAction func add(_ sender: UIButton) {
        
        let realmLoginGet = realm.objects(RealmLogins.self)
        errorPrint.isHidden = true
        
        if login.text != "", password.text != "" , (login.text?.hasSuffix("@gmail.com"))! {
            if String(describing: realmLoginGet) == "Results<RealmLogins> (\n\n)" ||
                String(describing: realmLoginGet) == "RealmLogins {\u{A}\u{9}login = ;\u{A}\u{9}pass = ;\u{A}}" {
                try! realm.write {
                    realmLogins.login = login.text!
                    realmLogins.pass  = password.text!
                    realm.add(realmLogins)
                }
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
        
        let realmLoginDel = realm.objects(RealmLogins.self)
        //print(realmLoginDel)
        try! realm.write({
            realm.delete(realmLoginDel)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorPrint.isHidden = true
        
        let realmLogins = realm.objects(RealmLogins.self)
        if String(describing: realmLogins) != "Results<RealmLogins> (\n\n)",
            String(describing: realmLogins) != "RealmLogins {\u{A}\u{9}login = ;\u{A}\u{9}pass = ;\u{A}}" {
            errorPrint.text = "Аккаунт на данном устройстве уже создан"
            errorPrint.isHidden = false
        }
    }
}

