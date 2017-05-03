//
//  Realm.swift
//  Mail All In One
//
//  Created by Анатолий on 16.04.17.
//  Copyright © 2017 AMProgram. All rights reserved.
//
//
//  ViewController.swift
//  Mail All In One
//
//  Copyright © 2017 AMProgram. All rights reserved.
//


import Foundation
import RealmSwift


class RealmLogins: Object {
    dynamic var login = ""
    dynamic var pass = ""
}

class RealmChosenFolder: Object {
    dynamic var chosenFolder = ""
}

class RealmMailHeader: Object {
    dynamic var mailHeader = ""
}

class RealmTest2: Object {
    dynamic var test1 = ""
}

class RMail: Object {
    dynamic var adresser = ""
    dynamic var theme = ""
    dynamic var date = ""
    dynamic var uid = ""
    dynamic var messageBody = ""
}

class RAllMail: RMail { }
class RSentMail: RMail { }
class RStarred: RMail { }
class RSpam: RMail { }
class RDrafts: RMail { }
class RTresh: RMail { }

class RMailBody: Object {
    dynamic var text = ""
    
}




