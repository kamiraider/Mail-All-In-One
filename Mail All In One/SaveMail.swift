//
//  SaveMail.swift
//  Mail All In One
//
//  Copyright © 2017 AMProgram. All rights reserved.
//

import Foundation
import RealmSwift

class SameMail {
    
    let realm = try! Realm()
    
    private func setArray <T:RMail>(realmS : Results<T>) -> [[String]] {
    
        var array = [[String]]()
        for i in 0..<realmS.count{
            let adress = realmS[i].adresser
            let theme = realmS[i].theme
            let date = realmS[i].date
            let uid = realmS[i].uid
            array.append([adress,theme,date,uid])
        }
        return array
    }
    
    private func addNewMail <T: RMail>(adresser: String, theme: String, date: String, uid: String, folder: T) {
        
        try! realm.write {
            folder.adresser = adresser
            folder.theme = theme
            folder.date = date
            folder.uid = uid
            realm.add(folder)
        }
    }
    
    // Main part of retention
    public func save <T: RMail> (adresser: String, theme: String, date: String, uid: String, folder: T) {
        let allMailFolder = realm.objects(T.self)
        let type = str(type: folder)
        if String(describing: allMailFolder) != "Results<" + type + "> (\n\n)", String(describing: allMailFolder) !=  type + " {\u{A}\u{9}adresser = ;\u{A}\u{9}theme = ;\u{A}\u{9}date = ;\u{A}}" {
            // Realm is add cycle to queue and insertForIndex didnt have any array to  insert
            var array = setArray(realmS: allMailFolder)
            array = array.insertForIndex(adresser: adresser, theme: theme, date: date, uid: uid)
            try! realm.write {
                realm.delete(realm.objects(T.self))
            }
            for i in array {
                addNewMail(adresser: i[0], theme: i[1], date: i[2], uid: i[3], folder: assigmentType(type: folder))
            }
        } else {
            addNewMail(adresser: adresser, theme: theme, date: date, uid: uid, folder: assigmentType(type: folder))
        }
    }

    public func retriveCount () -> Int {
        
        let currentFolder = realm.objects(RealmChosenFolder.self)
        
        if String(describing: currentFolder) != "Results<RealmChosenFolder> (\n\n)", String(describing: currentFolder) != "RealmChosenFolder {\u{A}\u{9}chosenFolder = ;\u{A}}" {
            switch currentFolder[0].chosenFolder {
            case "All Mail":
                let newValue = realm.objects(RAllMail.self)
                return newValue.count
            case "Sent Mail":
                let newValue = realm.objects(RSentMail.self)
                return newValue.count
            case "Starred":
                let newValue = realm.objects(RStarred.self)
                return newValue.count
            case "Spam":
                let newValue = realm.objects(RSpam.self)
                return newValue.count
            case "Drafts":
                let newValue = realm.objects(RDrafts.self)
                return newValue.count
            case "Trash":
                let newValue = realm.objects(RTresh.self)
                return newValue.count
            default:
                print("Ошибка возвращемого числа TableView")
                return 0
            }
        } else {
            return 0
        }
    }
    
    public func retriveCurrentFolder () -> [[String]] {
    
        let currentFolder = realm.objects(RealmChosenFolder.self)
        if String(describing: currentFolder) != "Results<RealmChosenFolder> (\n\n)", String(describing: currentFolder) != "RealmChosenFolder {\u{A}\u{9}chosenFolder = ;\u{A}}" {
            switch currentFolder[0].chosenFolder {
            case "All Mail":
                let array = setArray(realmS: realm.objects(RAllMail.self))
                return array
            case "Sent Mail":
                let array = setArray(realmS: realm.objects(RSentMail.self))
                return array
            case "Starred":
                let array = setArray(realmS: realm.objects(RStarred.self))
                return array
            case "Spam":
                let array = setArray(realmS: realm.objects(RSpam.self))
                return array
            case "Drafts":
                let array = setArray(realmS: realm.objects(RDrafts.self))
                return array
            case "Trash":
                let array = setArray(realmS: realm.objects(RTresh.self))
                return array
            default:
                return [["","",""]]
            }
        } else {
            return [["","",""]]
        }
    }
    
    private func str <T: RMail>(type: T) -> String {
        switch type {
        case is RAllMail: return "RAllMail"
        case is RSentMail: return "RSentMail"
        case is RSpam   : return "RSpam"
        case is RStarred: return "RStarred"
        case is RDrafts: return "RDrafts"
        case is RTresh: return "RTresh"
        default: return "RMail"
        }
    }
    
    private func assigmentType <T: RMail, G>(type: T) -> G {
        switch type {
        case is RAllMail    : return RAllMail() as! G
        case is RSentMail   : return RSentMail() as! G
        case is RSpam       : return RSpam() as! G
        case is RStarred    : return RStarred() as! G
        case is RDrafts      : return RDrafts() as! G
        case is RTresh      : return RTresh() as! G
        default             : return RMail() as! G
        }
    }
}




