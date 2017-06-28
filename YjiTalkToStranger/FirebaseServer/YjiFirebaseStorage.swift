//
//  YjiFirebaseStorage.swift
//  YjiTalkToStranger
//
//  Created by 季 雲 on 2017/06/08.
//  Copyright © 2017 Ericji. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase

class YjiFirebaseStorage: NSObject {
    
    typealias YjiStorageUploadImageClosure = (String?) -> Void
    let firebaseStorage = Storage.storage(url: "gs://yjitalktostranger.appspot.com/")
    var firebaseStorageRef: StorageReference {
        get {
            return firebaseStorage.reference()
        }
    }
    
    class var sharedInstance: YjiFirebaseStorage {
        struct Static {
            static let instance: YjiFirebaseStorage = YjiFirebaseStorage()
        }
        return Static.instance
    }
    
    func uploadImage(image: UIImage, toPath: String, completion: @escaping YjiStorageUploadImageClosure) {
        guard let data = UIImagePNGRepresentation(image) else {return}
        let riversRef = firebaseStorageRef.child(toPath)
        print(firebaseStorageRef.bucket)
        let _ = riversRef.putData(data, metadata: nil) { (metadata, error) in
            guard error == nil else {
                print(error.debugDescription)
                return
            }
            guard let imagePath = metadata?.downloadURL()?.path else {
                completion(nil)
                return
            }
            completion(imagePath)
        }
        
    }
}
