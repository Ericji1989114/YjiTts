//
//  YjiFirebaseRTDB.swift
//  YjiTalkToStranger
//
//  Created by 季 雲 on 2017/06/08.
//  Copyright © 2017 Ericji. All rights reserved.
//

import UIKit
import FirebaseDatabase

class YjiFirebaseRTDB: NSObject {
    
    let firebaseRef = FIRDatabase.database().reference()
    
    class var sharedInstance: YjiFirebaseRTDB {
        struct Static {
            static let instance: YjiFirebaseRTDB = YjiFirebaseRTDB()
        }
        return Static.instance
    }
    
    func update(path: String, value: [AnyHashable : Any]) {
        firebaseRef.child(path).updateChildValues(value)
    }
}
