//
//  YjiFirebaseAuth.swift
//  YjiTalkToStranger
//
//  Created by 季 雲 on 2017/06/07.
//  Copyright © 2017 Ericji. All rights reserved.
//

import UIKit
import FirebaseAuth


class YjiFirebaseAuth: NSObject {

    var currentUid: String? = nil
    typealias YjiAuthFbLoginClosure = (Bool) -> Void
    typealias YjiAuthtwLoginClosure = (Bool) -> Void

    class var sharedInstance: YjiFirebaseAuth {
        struct Static {
            static let instance: YjiFirebaseAuth = YjiFirebaseAuth()
        }
        return Static.instance
    }
    
    func addObserverForUserLoginState() {
        try! Auth.auth().signOut()
        Auth.auth().addStateDidChangeListener({ [weak self] (auth, user) in
            print(auth)
            print(user?.displayName ?? "")
            print(user?.uid ?? "")
            self?.currentUid = user?.uid
        })
    }
    
    func loginFb(token: String, closure: @escaping YjiAuthFbLoginClosure) {
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        Auth.auth().signIn(with: credential) { (user, error) in
            guard error == nil else {
                closure(false)
                return
            }
            closure(true)
        }
    }
    
    func loginTw(token: String, secret: String, closure: @escaping YjiAuthtwLoginClosure) {
        let credential = TwitterAuthProvider.credential(withToken: token, secret: secret)
        Auth.auth().signIn(with: credential) { (user, error) in
            guard error == nil else {
                closure(false)
                return
            }
            closure(true)
        }
    }

}
