//
//  YjiFirebaseStorage.swift
//  YjiTalkToStranger
//
//  Created by 季 雲 on 2017/06/08.
//  Copyright © 2017 Ericji. All rights reserved.
//

import UIKit

class YjiFirebaseStorage: NSObject {
    class var sharedInstance: YjiFirebaseStorage {
        struct Static {
            static let instance: YjiFirebaseStorage = YjiFirebaseStorage()
        }
        return Static.instance
    }
}
