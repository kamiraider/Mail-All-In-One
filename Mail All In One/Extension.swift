//
//  Extension.swift
//  Mail All In One
//
//  Copyright © 2017 AMProgram. All rights reserved.
//

import UIKit
import RealmSwift

extension String {
    
    func cutBetweenCharacters (from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                substring(with: substringFrom..<substringTo)
            }
        }
    }
}


extension Array {

    func insertForIndex (adresser: String, theme: String, date: String, uid: String) -> [[String]] {
        let arrayIn = [adresser, theme, date, uid]
        var array = self as! [[String]]
        
        if date > array[0][2] {
            array.insert(arrayIn, at: 0)
        } else {
            for i in 0...self.count-1 {
                if !(date > array[i][2]),
                    date != array[i][2],
                    i != 0,
                    date != array[i-1][2],
                    array.contentOf(array: arrayIn) {
                    array.insert(arrayIn, at: array.count - 1 - i)
                    return array
                }
            }
        }
        return array
    }
}


extension Array {
    
    func contentOf (array: [String]) -> Bool {
        
        var boolReturn = true
        let arraySelf = self as! [[String]]
        for i in arraySelf {
            if i[0] == array[0], i[1] == array[1], i[2] == array[2] {
                boolReturn = false
            }
        }
        return boolReturn
    }
}


extension Results {
    
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
    
    func insertForIndex (adresser: String, theme: String, date: String) -> [[String]] {
        let arrayIn = [adresser, theme, date]
        var array = /*self as! */[[String]]()
        
        if date > array[0][2] {
            array.insert(arrayIn, at: 0)
        } else {
            for i in 0...self.count-1 {
                if !(date > array[i][2]),
                    date != array[i][2],
                    i != 0,
                    date != array[i-1][2],
                    array.contentOf(array: arrayIn) {
                    
                        array.insert(arrayIn, at: array.count - 1 - i)
                        return array
                }
                
            }
        }
        return array
    }
}




















