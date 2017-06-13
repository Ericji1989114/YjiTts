//
//  YjiTabBarVc.swift
//  YjiTalkToStranger
//
//  Created by 季 雲 on 2017/05/31.
//  Copyright © 2017 Ericji. All rights reserved.
//

import UIKit
import FoldingTabBar

class YjiTabBarVc: YALFoldingTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //leftBarItems
        let firstItem = YALTabBarItem(
            itemImage: UIImage(named: "nearby_icon")!,
            leftItemImage: nil,
            rightItemImage: nil
        )
        let secondItem = YALTabBarItem(
            itemImage: UIImage(named: "search_icon")!,
            leftItemImage: nil,
            rightItemImage: nil
        )
        let thirdItem = YALTabBarItem(
            itemImage: UIImage(named: "chats_icon")!,
            leftItemImage: nil,
            rightItemImage: nil
        )
        let fourthItem = YALTabBarItem(
            itemImage: UIImage(named: "profile_icon")!,
            leftItemImage: nil,
            rightItemImage: nil
        )
        self.leftBarItems = [firstItem, secondItem]
        self.rightBarItems = [thirdItem, fourthItem]
        self.centerButtonImage = UIImage(named:"plus_icon")!
        self.selectedIndex = 1
        self.tabBarView.extraTabBarItemHeight = YALExtraTabBarItemsDefaultHeight;
        self.tabBarView.offsetForExtraTabBarItems = YALForExtraTabBarItemsDefaultOffset;
        self.tabBarView.backgroundColor = UIColor.clear
        self.tabBarView.tabBarColor = UIColor(red: 72.0/255.0, green: 211.0/255.0, blue: 178.0/255.0, alpha: 1)
        self.tabBarViewHeight = YALTabBarViewDefaultHeight;
        self.tabBarView.tabBarViewEdgeInsets = YALTabBarViewHDefaultEdgeInsets;
        self.tabBarView.tabBarItemsEdgeInsets = YALTabBarViewItemsDefaultEdgeInsets;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
