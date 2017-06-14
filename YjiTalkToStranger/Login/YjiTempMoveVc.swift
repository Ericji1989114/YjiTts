//
//  YjiTempMoveVc.swift
//  YjiTalkToStranger
//
//  Created by 季 雲 on 2017/06/14.
//  Copyright © 2017 Ericji. All rights reserved.
//

import UIKit

class YjiTempMoveVc: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        YjiRootVcManager.moveToTabBarVc()
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
