//
//  YjiUserInfoChangeVc.swift
//  YjiTalkToStranger
//
//  Created by 季 雲 on 2017/06/12.
//  Copyright © 2017 Ericji. All rights reserved.
//

import UIKit
import TextFieldEffects
import ActionSheetPicker_3_0

class YjiUserInfoChangeVc: YjiBaseVc, UITextFieldDelegate, UIViewControllerTransitioningDelegate, ImagePickerDelegate {
    
    @IBOutlet weak var nickName: HoshiTextField!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var birthBtn: UIButton!
    private var birthUnixTime: TimeInterval? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUid = YjiFirebaseAuth.sharedInstance.currentUid else {return}
        let userInfo = YjiRealmManager.sharedInstance.userInfo(uid: currentUid)
        if let image = UIImage(data: (userInfo?.avatarImage)!) {
            userAvatar.image = image
        }
        if let text = userInfo?.userName {
            nickName.text = text
        }
        if let unixTime = userInfo?.birthUnixTime.value {
            birthBtn.setTitle(YjiCommonFunc.stringYMD(unixTime: unixTime), for: UIControlState.normal)
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
    
    
    @IBAction func onTapAvatarSetting(_ sender: UITapGestureRecognizer) {
        var config = Configuration()
        config.doneButtonTitle = "Finish"
        config.noImagesTitle = "Sorry! There are no images here!"
        config.recordLocation = false
        config.allowMultiplePhotoSelection = false
        let imagePickerController = ImagePickerController(configuration: config)
        imagePickerController.imageLimit = 1
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: ImagePickerDelegate
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
        userAvatar.set(image: images[0], focusOnFaces: true)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else { return }
        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        imagePicker.present(lightbox, animated: true, completion: nil)
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TKFadeInAnimator(transitionDuration: 0.5, startingAlpha: 0.8)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
}
