//
//  YjiAuthMonitor.swift
//  YjiTalkToStranger
//
//  Created by 季 雲 on 2017/06/07.
//  Copyright © 2017 Ericji. All rights reserved.
//

import UIKit
import FirebaseAuth

class YjiAuthMonitor: NSObject {

    class var sharedInstance: YjiAuthMonitor {
        struct Static {
            static let instance: YjiAuthMonitor = YjiAuthMonitor()
        }
        return Static.instance
    }
    
    func addObserverForUserLoginState() {
        try! FIRAuth.auth()?.signOut()
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            print(auth)
            print(user?.displayName ?? "")
            print(user?.uid ?? "")
        })
    }

}
