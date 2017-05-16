//
//  ViewController.swift
//  Mail All In One
//
//  Copyright © 2017 AMProgram. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftKeychainWrapper

class ViewController: UIViewController {
    
    private let realm = try! Realm()
    
    @IBAction func mailList(_ sender: UIButton) {
        let realmChosenFolder = RealmChosenFolder()
        if KeychainWrapper.standard.string(forKey: "Login") != nil {
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

