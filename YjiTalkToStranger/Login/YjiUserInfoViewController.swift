//
//  YjiUserInfoViewController.swift
//  YjiTalkToStranger
//
//  Created by 季 雲 on 2017/05/31.
//  Copyright © 2017 Ericji. All rights reserved.
//

import UIKit
import TextFieldEffects
import ActionSheetPicker_3_0

class YjiUserInfoViewController: YjiBaseVc, UITextFieldDelegate, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var birthBtn: UIButton!
    private var birthUnixTime: TimeInterval? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapBirthBtn(btn: UIButton) {
        let datepicker = ActionSheetDatePicker(title: "Select Birthday", datePickerMode: UIDatePickerMode.date, selectedDate: Date(), doneBlock: { [weak self] (picker, value, index) in
            guard value != nil else {return}
            guard let birthDate = value as? Date else {return}
            btn.setTitle(YjiCommonFunc.stringYMD(date: birthDate), for: UIControlState.normal)
            self?.birthUnixTime = (value as! Date).timeIntervalSince1970
            
        }, cancel: { (_) in
            
        }, origin: self.view)
        datepicker?.show()
    }
    
    @IBAction func onTapOKBtn(btn: TKTransitionSubmitButton) {
        btn.animate(1, completion: { () -> () in
            let secondVC = UIViewController()
            secondVC.transitioningDelegate = self
            self.present(secondVC, animated: true, completion: nil)
        })
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TKFadeInAnimator(transitionDuration: 0.5, startingAlpha: 0.8)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
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
