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

    typealias YjiAuthFbLoginClosure = (Bool) -> Void
    typealias YjiAuthtwLoginClosure = (Bool) -> Void

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
    
    func loginFb(token: String, closure: @escaping YjiAuthFbLoginClosure) {
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: token)
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            guard error == nil else {
                closure(false)
                return
            }
            closure(true)
        }
    }
    
    func loginTw(token: String, secret: String, closure: @escaping YjiAuthtwLoginClosure) {
        let credential = FIRTwitterAuthProvider.credential(withToken: token, secret: secret)
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            guard error == nil else {
                closure(false)
                return
            }
            closure(true)
        }
    }

}