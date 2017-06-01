//
//  ViewController.swift
//  YjiTalkToStranger
//
//  Created by 季 雲 on 2017/05/29.
//  Copyright © 2017 Ericji. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import TWMessageBarManager

class ViewController: YjiBaseVc {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTapFbBtn(_ sender: Any) {
        let loginMg = FBSDKLoginManager()
        loginMg.logOut()
        loginMg.logIn(withReadPermissions: ["email"], from: self) { (resultValue, fbError) in
            guard fbError == nil else {return}
            guard let result = resultValue else {return}
            guard result.isCancelled == false else {return}
            guard FBSDKAccessToken.current() != nil else {return}
            FBSDKAccessToken.setCurrent(result.token)
            let dictInfo = ["fields" : "id,name"]
            let request = FBSDKGraphRequest(graphPath: "me", parameters: dictInfo)
            request?.start(completionHandler: { (_, result, _) in
                print(result as! [String : Any])
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    // ...
                    TWMessageBarManager.sharedInstance().showMessage(withTitle: "Account Created", description: "Your account was successfully created", type: .success)
                    self.navigationController?.pushViewController(UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "YjiUserInfoViewController"), animated: true)

                }
            })
            
        }
    }

    @IBAction func anonymousLogin(_ sender: Any) {
        FIRAuth.auth()?.signInAnonymously() { (user, error) in
            // ...
            let isAnonymous = user!.isAnonymous  // true
        }
        
    }
}

