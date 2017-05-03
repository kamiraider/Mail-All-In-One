//
//  TextFildMailController.swift
//  Mail All In One
//
//  Copyright © 2017 AMProgram. All rights reserved.
// https://github.com/KuDji/Mail-All-In-One

import UIKit
import Postal
import RealmSwift

class TextFildMailController: UIViewController {
    
    var realm = try! Realm()
    let mailViewController = MailViewController()
    let saveMail = SameMail()
    @IBOutlet weak var adressee: UILabel!
    @IBOutlet weak var theme: UILabel!
    @IBOutlet weak var messageBody: UITextView!
    
    public func getMessageBody (uid: Int, folder: String) {
        let realmLogins = realm.objects(RealmLogins.self)
        let acount = realmLogins[0]
        let postal = Postal(configuration: .gmail(login: acount.login, password: .plain(acount.pass)))
        postal.connect { result in return }
        
        let index = NSIndexSet(index: uid)
        postal.fetchMessages(folder, uids: index as IndexSet, flags: [ .body ], onMessage: {
            email in
            var messageBody: MailData?
            switch String(describing: email.body?.allParts.next()?.data?.encoding) {
            case "Optional(base64)"             :
                messageBody = MailData(rawData: (email.body?.allParts.next()?.data?.rawData)!, encoding: .base64)
            case  "Optional(quotedPrintable)"   :
                messageBody = MailData(rawData: (email.body?.allParts.next()?.data?.rawData)!, encoding: .quotedPrintable)
            case   "Optional(binary)"           :
                messageBody = MailData(rawData: (email.body?.allParts.next()?.data?.rawData)!, encoding: .binary)
            default                             :
                break
            }
            let messageDecoded = String(data: (messageBody?.decodedData)!, encoding: .utf8)
            self.messageBody.text! = messageDecoded!
            self.selectAndSave(message: messageDecoded!)
        }, onComplete: {
            error in
            if let error = error {
                print("an error occured: \(error)")
            }
        })
    }
    
    // row = index in realm
    private func configurationView () {
        if let row = letterDetail {
            UserDefaults.standard.set(row, forKey: "row")
        }
    }
    
    // sent type of chosen folder
    private func loadMail () {
        let realmChosenFolder = realm.objects(RealmChosenFolder.self)[0].chosenFolder
        switch realmChosenFolder {
        case "All Mail"     :
            setHead(realmFolder: realm.objects(RAllMail.self))
        case "Sent Mail"    :
            setHead(realmFolder: realm.objects(RSentMail.self))
        case "Starred"      :
            setHead(realmFolder: realm.objects(RStarred.self))
        case "Spam"         :
            setHead(realmFolder: realm.objects(RSpam.self))
        case "Drafts"       :
            setHead(realmFolder: realm.objects(RDrafts.self))
        case "Trash"        :
            setHead(realmFolder: realm.objects(RTresh.self))
        default             :
            setHead(realmFolder: realm.objects(RMail.self))
        }
    }
    
    // save message body to realm date base
    private func selectAndSave (message: String) {
        let realmChosenFolder = realm.objects(RealmChosenFolder.self)[0].chosenFolder
        switch realmChosenFolder {
        case "All Mail"     :
            save(realmFolder: realm.objects(RAllMail.self), message: message)
        case "Sent Mail"    :
            save(realmFolder: realm.objects(RSentMail.self), message: message)
        case "Starred"      :
            save(realmFolder: realm.objects(RStarred.self), message: message)
        case "Spam"         :
            save(realmFolder: realm.objects(RSpam.self), message: message)
        case "Drafts"       :
            save(realmFolder: realm.objects(RDrafts.self), message: message)
        case "Trash"        :
            save(realmFolder: realm.objects(RTresh.self), message: message)
        default             :
            break
        }
    }
    
    private func save <T: RMail>(realmFolder: Results<T>, message: String) {
        try! realm.write {
            realmFolder[UserDefaults.standard.object(forKey: "row") as! Int].messageBody = message
            realm.add(realmFolder)
        }
        let new = realm.objects(RAllMail.self)
        print(new)
    }

    // sent setting for response and set header and previously saved check message
    private func setHead <T: RMail>(realmFolder: Results<T>) {
        
        if realmFolder[UserDefaults.standard.object(forKey: "row") as! Int].messageBody == "" {
            let realmChosenFolder = realm.objects(RealmChosenFolder.self)[0].chosenFolder
            getMessageBody(uid: Int(realmFolder[UserDefaults.standard.object(forKey: "row") as! Int].uid)!,
                           folder: mailViewController.getFolderIndex(name: realmChosenFolder))
        } else {
            messageBody.text! = realmFolder[UserDefaults.standard.object(forKey: "row") as! Int].messageBody
        }
        adressee.text = realmFolder[UserDefaults.standard.object(forKey: "row") as! Int].adresser
        theme.text = realmFolder[UserDefaults.standard.object(forKey: "row") as! Int].theme
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMail ()
    }
    
    // save uid of chousen mail
    var letterDetail: Int? {
        didSet {
            configurationView()
        }
    }
}
