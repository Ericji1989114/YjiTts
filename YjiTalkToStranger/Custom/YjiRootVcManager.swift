//
//  YjiRootVcManager.swift
//  YjiTalkToStranger
//
//  Created by 季 雲 on 2017/05/31.
//  Copyright © 2017 Ericji. All rights reserved.
//

import UIKit

class YjiRootVcManager: NSObject {
    class func moveToTabBarVc() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let tabBarVc = storyboard.instantiateViewController(withIdentifier: "YjiTabBarVc") as? YjiTabBarVc else {return}
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        appdelegate.window?.rootViewController = tabBarVc
    }
}
