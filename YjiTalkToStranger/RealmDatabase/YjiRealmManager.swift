//
//  YjiRealmManager.swift
//  YjiTalkToStranger
//
//  Created by 季 雲 on 2017/06/14.
//  Copyright © 2017 Ericji. All rights reserved.
//

import UIKit
import RealmSwift

class YjiRealmUser: Object {
    dynamic var userName = ""
    dynamic var birthUnixTime: Double = 0.0
    dynamic var uid = ""
    dynamic var avatarImage: Data? = nil

    override static func primaryKey() -> String? {
        return "uid"
    }
}

class YjiRealmManager: NSObject {
    
    var realm: Realm!
    
    class var sharedInstance: YjiRealmManager {
        struct Static {
            static let instance: YjiRealmManager = YjiRealmManager()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        var config = Realm.Configuration()
        guard config.fileURL != nil else {return}
        config.fileURL = config.fileURL?.deletingLastPathComponent().appendingPathComponent("YjiLocalDB.realm")
        do {
            realm = try Realm(configuration: config)
        } catch {
            print("local realm database is not be finish")
        }
    }
    
    // MARK: - User
    func addUserInfo(uid: String, userName: String, avatarImage: Data, birthUnixTime: Double) {
        let object = YjiRealmUser(value: ["uid" : uid, "userName" : userName, "avatarImage" : avatarImage, "birthUnixTime" : birthUnixTime])
        do {
            try realm.write {
                realm.add(object, update: true)
            }
        } catch  {
            print("addUserInfo failure")
        }
    }
    
    func userInfo(uid: String) -> YjiRealmUser? {
        var results = realm.objects(YjiRealmUser.self)
        results = results.filter("%K = %@", "uid", uid)
        if results.count > 0 {
            print(results.first?.uid ?? "haha")
            return results.first
        } else {
            return nil
        }
    }
    
}
