//
//  YjiBaseVc.swift
//  YjiTalkToStranger
//
//  Created by 季 雲 on 2017/05/31.
//  Copyright © 2017 Ericji. All rights reserved.
//

import UIKit
import SnapKit

class YjiBaseVc: UIViewController, UINavigationControllerDelegate, NVActivityIndicatorViewable {

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let navigationController = self.navigationController else {
            return
        }
        navigationController.delegate = self
        navigationController.navigationBar.barTintColor = UIColor(red: 73.0/255.0, green: 211.0/255.0, blue: 178.0/255.0, alpha: 0.5)
        let tapViewGesture = UITapGestureRecognizer(target: self, action: #selector(YjiBaseVc.dismissKeyboard))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapViewGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: - Navigation Delegate
    public func navigationController(_ navigationController: UINavigationController,
                                     animationControllerFor operation: UINavigationControllerOperation,
                                     from fromVC: UIViewController,
                                     to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ZBFallenBricksAnimator()
    }

    // MARK:- activity indicator
    func startLoading() {
        startAnimating(CGSize(width: 30, height: 30), message: "Loading...", type: NVActivityIndicatorType(rawValue: 14))
    }
    
    func stopLoading() {
        stopAnimating()
    }

}
