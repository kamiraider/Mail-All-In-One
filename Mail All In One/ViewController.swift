//
//  ViewController.swift
//  Mail All In One
//
//  Copyright © 2017 AMProgram. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    private let realm = try! Realm()
    
    @IBAction func mailList(_ sender: UIButton) {
        let realmChosenFolder = RealmChosenFolder()
        let logins = realm.objects(RealmLogins.self)
        if String(describing: logins) != "Results<RealmLogins> (\n\n)",
            String(describing: logins) !=  "RealmLogins {\u{A}\u{9}login = ;\u{A}\u{9}pass = ;\u{A}}" {
            
            realmChosenFolder.chosenFolder = sender.currentTitle!
            try! realm.write({
                realm.add(realmChosenFolder)
            })
            performSegue(withIdentifier: "MailList", sender: sender.currentTitle!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let realmDelChoseFolder = realm.objects(RealmChosenFolder.self)
        try! realm.write {
            realm.delete(realmDelChoseFolder)
        }
    }
}

