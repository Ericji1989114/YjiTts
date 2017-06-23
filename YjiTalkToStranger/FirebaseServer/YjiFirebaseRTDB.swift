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
    // matching handle member
    var likeUids: [String] = []
    var fromUids: [String] = []
    // closure
    typealias YjiRTDBSyncUserInfoClosure = (Bool) -> Void
    
    class var sharedInstance: YjiFirebaseRTDB {
        struct Static {
            static let instance: YjiFirebaseRTDB = YjiFirebaseRTDB()
        }
        return Static.instance
    }
    
    func update(path: String, value: [AnyHashable : Any]) {
        firebaseRef.child(path).updateChildValues(value)
    }
    
    // MARK:- setting value to likeMe list and likeOthers list
    func addLikeUid(likeUid: String, fromUid: String) {
        let likesRef = firebaseRef.child("likes")
        likeUids.append(likeUid)
        fromUids.append(fromUid)
        likesRef.child("/\(fromUid)" + "/setLikes").setValue(likeUids)
        likesRef.child("/\(likeUid)" + "/getLikes").setValue(fromUids)
    }
    
    
    // MARK:- monitor likeMe list and be likeOthers list
    // init likes and be liked array
    func observeInitialLikesValue() {
        guard let currentUid = YjiFirebaseAuth.sharedInstance.currentUid else {return}
        let userLikeRef = firebaseRef.child("likes" + "/\(currentUid)")
        userLikeRef.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            guard let dictInfo = snapshot.value as? [String : Any] else{return}
            if let getLikes = dictInfo["getLikes"] as? [String] {
                self?.fromUids = getLikes
            }
            if let setLikes = dictInfo["setLikes"] as? [String] {
                self?.likeUids = setLikes
            }
        })
    }
    
    func observeChangeLikesValue() {
        guard let currentUid = YjiFirebaseAuth.sharedInstance.currentUid else {return}
        let userLikeRef = firebaseRef.child("likes" + "/\(currentUid)")
        userLikeRef.observe(.value, with: { [weak self] (snapshot) in
            guard let dictInfo = snapshot.value as? [String : Any] else{return}
            if let getLikes = dictInfo["getLikes"] as? [String] {
                // get like from others
                let filterArr = getLikes.filter{self?.fromUids.contains($0) == false}
                if filterArr.count == 0 {
                    self?.fromUids = getLikes
                } else {
                    // have new value: like from other uid
                    let newValue = filterArr[0]
                    // match it with setlikes
                    if self?.likeUids.contains(newValue) == true {
                        // TODO: Success alert congratulation
                        
                        // self getlike list recover
                        self?.firebaseRef.child("likes" + "/\(currentUid)" + "/getLikes").setValue(self?.fromUids)
                        // other setlike list update
                        self?.firebaseRef.child("likes" + "/\(newValue)" + "/setLikes").observeSingleEvent(of: .value, with: { (snapshot) in
                            guard var otherInfo = snapshot.value as? [String] else {return}
                            if otherInfo.contains(currentUid) {
                                otherInfo.remove(at: otherInfo.index(of: currentUid)!)
                            }
                            self?.firebaseRef.child("likes" + "/\(newValue)" + "/setLikes").setValue(otherInfo)
                        })
                    }
                }
            }
            if let setLikes = dictInfo["setLikes"] as? [String] {
                // set like to others
                let filterArr = setLikes.filter{self?.likeUids.contains($0) == false}
                if filterArr.count == 0 {
                    self?.likeUids = setLikes
                } else {
                    // have new value: self like uid
                    let newValue = filterArr[0]
                    // match it with getlikes
                    if self?.fromUids.contains(newValue) == true {
                        // TODO: Success alert congratulation

                        // self setlike list recover
                        self?.firebaseRef.child("likes" + "/\(currentUid)" + "/setLikes").setValue(self?.likeUids)
                        // other getlike list update
                        self?.firebaseRef.child("likes" + "/\(newValue)" + "/getLikes").observeSingleEvent(of: .value, with: { (snapshot) in
                            guard var otherInfo = snapshot.value as? [String] else {return}
                            if otherInfo.contains(currentUid) {
                                otherInfo.remove(at: otherInfo.index(of: currentUid)!)
                            }
                            self?.firebaseRef.child("likes" + "/\(newValue)" + "/getLikes").setValue(otherInfo)
                        })
                    }
                }
                
            }
        })
    }
    
    // MARK: - Get UserList to local db
    func getAllUserId(completion: @escaping YjiRTDBSyncUserInfoClosure) {
        self.firebaseRef.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictInfo = snapshot.value as? [String : Any] else{return}
            let dbManager = YjiRealmManager.sharedInstance
            for (key, value) in dictInfo {
                guard let userInfo = value as? [String : Any] else {continue}
                dbManager.addUserInfo(uid: key, userName: userInfo["userName"] as? String, avatarImage: nil, birthUnixTime: nil)
            }
            completion(true)
        })
    }

}
