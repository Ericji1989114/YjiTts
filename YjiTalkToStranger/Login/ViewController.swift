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
import TwitterKit

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
            let _ = request?.start(completionHandler: { (_, _, _) in
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    // ...
                    TWMessageBarManager.sharedInstance().showMessage(withTitle: "Account Created", description: "Your account was successfully created", type: .success)
                    self.navigationController?.pushViewController(UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "YjiUserInfoViewController"), animated: true)

                }
            })
        }
    }

    @IBAction func onTapTwBtn(_ sender: Any) {
        Twitter.sharedInstance().logIn(completion: { (session, error) in
            guard let twInfo = session else {
                print("error: \(String(describing: error?.localizedDescription))")
                return
            }
            let authToken = twInfo.authToken
            let authTokenSecret = twInfo.authTokenSecret
            let credential = FIRTwitterAuthProvider.credential(withToken: authToken, secret: authTokenSecret)
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                // ...
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Account Created", description: "Your account was successfully created", type: .success)
                self.navigationController?.pushViewController(UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "YjiUserInfoViewController"), animated: true)
                
            }
        })
    }
    
//    @IBAction func onTapButton(_ button: TKTransitionSubmitButton) {
//        button.animate(1, completion: { () -> () in
//            let secondVC = SecondViewController()
//            secondVC.transitioningDelegate = self
//            self.present(secondVC, animated: true, completion: nil)
//        })
//    }
}

