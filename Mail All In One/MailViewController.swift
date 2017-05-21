//
//  MailViewController.swift
//  Mail All In One
//
//  Copyright © 2017 AMProgram. All rights reserved.
//

import UIKit
import Postal
import RealmSwift
import SwiftKeychainWrapper

class MailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var stopChangeTableView = false
    private let realm = try! Realm()
    private let saveMail = SameMail()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func menu(_ sender: UIBarButtonItem) {
        stopChangeTableView = true
    }
    // the edit button (is not working now)
    @IBAction func change(_ sender: UIBarButtonItem) {
        tableView.reloadData()
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saveMail.retriveCount()
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MailCell", for: indexPath) as! TableViewCell
        let currentFolder = realm.objects(RealmChosenFolder.self)
     
        if String(describing: currentFolder) != "Results<RealmChosenFolder> (\n\n)",
            String(describing: currentFolder) != "RealmChosenFolder {\u{A}\u{9}chosenFolder = ;\u{A}}"
        {
            switch currentFolder[0].chosenFolder {
            case "All Mail":
                let realmArray = realm.objects(RAllMail.self)
                return retutnCell(realmCell: realmArray, index: indexPath.row, cell: cell, currentFolder: String(describing: currentFolder))
            case "Sent Mail":
                let realmArray = realm.objects(RSentMail.self)
                return retutnCell(realmCell: realmArray, index: indexPath.row, cell: cell, currentFolder: String(describing: currentFolder))
            case "Starred":
                let realmArray = realm.objects(RStarred.self)
                return retutnCell(realmCell: realmArray, index: indexPath.row, cell: cell, currentFolder: String(describing: currentFolder))
            case "Spam":
                let realmArray = realm.objects(RSpam.self)
                return retutnCell(realmCell: realmArray, index: indexPath.row, cell: cell, currentFolder: String(describing: currentFolder))
            case "Drafts":
                let realmArray = realm.objects(RDrafts.self)
                return retutnCell(realmCell: realmArray, index: indexPath.row, cell: cell, currentFolder: String(describing: currentFolder))
            case "Trash":
                let realmArray = realm.objects(RTresh.self)
                return retutnCell(realmCell: realmArray, index: indexPath.row, cell: cell, currentFolder: String(describing: currentFolder))
            default:
                break
            }
        }
        let realmArray = realm.objects(RMail.self)
        return retutnCell(realmCell: realmArray, index: indexPath.row, cell: cell, currentFolder: String(describing: currentFolder))
    }
    
    private func retutnCell <T: RMail>(realmCell: Results<T>, index: Int, cell: TableViewCell, currentFolder: String) -> UITableViewCell {
        
        if currentFolder != "Results<RealmChosenFolder> (\n\n)",
            currentFolder != "RealmChosenFolder {\u{A}\u{9}chosenFolder = ;\u{A}}"
        {
            cell.adresser.text = realmCell[index].adresser
            cell.theme.text = realmCell[index].theme
            cell.dateOfRecive.text = realmCell[index].date
        } else {
            cell.adresser.text = ""
            cell.theme.text = ""
            cell.dateOfRecive.text = ""
        }
        return cell
    }
    
    // the edit button (is not working now)
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //cellsArray.remove(at: indexPath.row)
            //UserDefaults.standard.set(cellsArray, forKey: "StageArray")
            tableView.reloadData()
        }
    }
  
    private func getAllMailRealm (login: String, password: String, folder: String, folderSegueName: String) {
        let postal = Postal(configuration: .gmail(login: login, password: .plain(password)))
        postal.connect { result in return }
        let index = NSIndexSet(index: 0)
        postal.fetchMessages(folder, uids: index as IndexSet, flags: [ .fullHeaders ], onMessage: { email in
            let mailCount = email.uid
            
            for i in 1...mailCount {
                let index = NSIndexSet(index: Int(i))
                postal.fetchMessages(folder, uids: index as IndexSet, flags: [ .fullHeaders ], onMessage: { [weak self] email in
                    // Break pesponse when view is closed
                    if (self?.stopChangeTableView)! { return }
                    // perform save date
                    let adreesMan = String(describing: email.header?.from)
                    let themeEmail = String(describing: email.header?.subject)
                    let dateEmail = String(describing: email.header?.receivedDate)
                    if let adress = adreesMan.cutBetweenCharacters(from: "\u{0022}", to: "\u{0022}"),
                        var date = dateEmail.cutBetweenCharacters(from: "2", to: " +"),
                        let theme = themeEmail.cutBetweenCharacters(from: "(\"", to: "\")") {
                        date = "2" + date
                        self?.saveAndCheckMail(adresser: adress, theme: theme, date: date, uid: String(describing: email.uid), folder: folderSegueName)
                    }
                    self?.tableView.reloadData()
                }, onComplete: { error in if let error = error { print("an error occured: \(error)") } })
            }
        }, onComplete: { error in if let error = error { print("an error occured: \(error)") } })
    }
    
    // Initialization of save mail
    private func saveAndCheckMail (adresser: String, theme: String, date: String, uid: String, folder: String) {
        switch folder {
        case "All Mail": saveMail.save(adresser: adresser, theme: theme, date: date, uid: uid, folder: RAllMail())
        case "Sent Mail": saveMail.save(adresser: adresser, theme: theme, date: date, uid: uid, folder: RSentMail())
        case "Starred": saveMail.save(adresser: adresser, theme: theme, date: date, uid: uid, folder: RStarred())
        case "Spam": saveMail.save(adresser: adresser, theme: theme, date: date, uid: uid, folder: RSpam())
        case "Drafts": saveMail.save(adresser: adresser, theme: theme, date: date, uid: uid, folder: RDrafts())
        case "Trash": saveMail.save(adresser: adresser, theme: theme, date: date, uid: uid, folder: RTresh())
        default: return
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // check segue id
        if segue.identifier == "MailText" {
            // way of cell
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = TextFildMailController()
                controller.letterDetail = indexPath.row
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let realmChosenFolder = realm.objects(RealmChosenFolder.self)
        getAllMailRealm(login: KeychainWrapper.standard.string(forKey: "Login")!,
                        password: KeychainWrapper.standard.string(forKey: "Pass")!,
                        folder: getFolderIndex(name: realmChosenFolder[0].chosenFolder),
                        folderSegueName: realmChosenFolder[0].chosenFolder)
    }
 
    override func viewDidDisappear(_ animated: Bool) {
        stopChangeTableView = true
    }
    
    public func getFolderIndex (name: String) -> String {
        switch name {
        case "All Mail": return "[Gmail]/&BBIEQQRP- &BD8EPgRHBEIEMA-"
        case "Sent Mail": return"[Gmail]/&BB4EQgQ,BEAEMAQyBDsENQQ9BD0ESwQ1-"
        case "Starred": return"[Gmail]/&BB8EPgQ8BDUERwQ1BD0EPQRLBDU-"
        case "Spam": return"[Gmail]/&BCEEPwQwBDw-"
        case "Drafts": return"[Gmail]/&BCcENQRABD0EPgQyBDgEOgQ4-"
        case "Trash": return"[Gmail]/&BBoEPgRABDcEOAQ9BDA-"
        default: return "Error - not found"
        }
    }
    
    enum folderName: String {
        case AllMail = "[Gmail]/&BBIEQQRP- &BD8EPgRHBEIEMA-"
        case SentMail = "[Gmail]/&BB4EQgQ,BEAEMAQyBDsENQQ9BD0ESwQ1-"
        case Starred = "[Gmail]/&BB8EPgQ8BDUERwQ1BD0EPQRLBDU-"
        case Spam = "[Gmail]/&BCEEPwQwBDw-"
        case Drafts = "[Gmail]/&BCcENQRABD0EPgQyBDgEOgQ4-"
        case Trash = "[Gmail]/&BBoEPgRABDcEOAQ9BDA-"
    }
}




