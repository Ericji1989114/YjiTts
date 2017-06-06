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
import KLCPopup

class YjiPhotoPickerView: UIView {
    
    let mTopColorViewHeight: CGFloat = 63.0
    var mTopColor: UIColor?
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        if mTopColor != nil {
            let bezierPath = UIBezierPath()
            bezierPath.move(to: CGPoint(x: 0, y: 0))
            bezierPath.addLine(to: CGPoint(x: 0, y: mTopColorViewHeight))
            bezierPath.addLine(to: CGPoint(x: self.width, y: mTopColorViewHeight))
            bezierPath.addLine(to: CGPoint(x: self.width, y: 0))
            bezierPath.close()
            mTopColor!.setFill()
            bezierPath.fill()
        }
    }
    
    init(topColor: UIColor) {
        super.init(frame: CGRect.zero)
        mTopColor = topColor
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class YjiUserInfoViewController: YjiBaseVc, UITextFieldDelegate, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var birthBtn: UIButton!
    private var birthUnixTime: TimeInterval? = 0
    private let popupContentV = YjiPhotoPickerView(topColor: UIColor(red: 185.0/255.0, green: 231.0/255.0, blue: 128.0/255.0, alpha: 1))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // contentView layout setting

        popupContentV.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        popupContentV.cornerRadius = 20
        
        let titleLbl = UILabel()
        titleLbl.text = "Let's set your avatar"
        titleLbl.textColor = UIColor.white
        titleLbl.font = UIFont(name: "Arial-BoldMT", size: 20)
        titleLbl.textAlignment = .center
        popupContentV.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.centerX.equalTo(popupContentV)
        }
        
        let cameraIcon = UIImageView(image: UIImage(named: "take_photo"))
        popupContentV.addSubview(cameraIcon)
        cameraIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.top.equalTo(titleLbl.snp.bottom).offset(40)
            make.left.equalTo(40)
        }
        
        let cameraBtn = UIButton()
        cameraBtn.setTitle("take a photo", for: .normal)
        cameraBtn.setTitleColor(UIColor.black, for: .normal)
        popupContentV.addSubview(cameraBtn)
        cameraBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(cameraIcon)
            make.left.equalTo(cameraIcon.snp.right).offset(30)
        }
        
        let separateline1 = UIView()
        separateline1.backgroundColor = UIColor.gray
        popupContentV.addSubview(separateline1)
        separateline1.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(0.5)
            make.top.equalTo(cameraIcon.snp.bottom).offset(20)
        }
        
        let albumIcon = UIImageView(image: UIImage(named: "select_album"))
        popupContentV.addSubview(albumIcon)
        albumIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.top.equalTo(separateline1.snp.bottom).offset(20)
            make.left.equalTo(cameraIcon)
        }
        
        let albumBtn = UIButton()
        albumBtn.setTitle("select from album", for: .normal)
        albumBtn.setTitleColor(UIColor.black, for: .normal)
        popupContentV.addSubview(albumBtn)
        albumBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(albumIcon)
            make.left.equalTo(albumIcon.snp.right).offset(30)
        }
        
        let separateline2 = UIView()
        separateline2.backgroundColor = UIColor.gray
        popupContentV.addSubview(separateline2)
        separateline2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(separateline1)
            make.top.equalTo(albumBtn.snp.bottom).offset(20)
        }
        
        let cancelBtn = UIButton()
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.setTitleColor(UIColor.white, for: .normal)
        cancelBtn.addTarget(self, action: #selector(self.dismissButtonPressed(sender:)), for: .touchUpInside)
        cancelBtn.backgroundColor = UIColor(red: 185.0/255.0, green: 231.0/255.0, blue: 128.0/255.0, alpha: 1)
        cancelBtn.cornerRadius = 10
        popupContentV.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(popupContentV)
            make.width.equalTo(75)
            make.height.equalTo(40)
            make.bottom.equalTo(-20)
        }
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
    
    @IBAction func onTapAvatarSetting(_ sender: UITapGestureRecognizer) {
        let popupLayout = KLCPopupLayout(horizontal: KLCPopupHorizontalLayout.center, vertical: KLCPopupVerticalLayout.center)
        let popup = KLCPopup(contentView: popupContentV,
                             showType: KLCPopupShowType.bounceInFromTop,
                             dismissType: KLCPopupDismissType.bounceOutToTop,
                             maskType: KLCPopupMaskType.none,
                             dismissOnBackgroundTouch: false,
                             dismissOnContentTouch: false)
        popup?.show(with: popupLayout)
        
    }
    
    func dismissButtonPressed(sender: Any) {
        popupContentV.dismissPresentingPopup()
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
