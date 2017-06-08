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

class YjiUserInfoViewController: YjiBaseVc, UITextFieldDelegate, UIViewControllerTransitioningDelegate, ImagePickerDelegate {
    
    @IBOutlet weak var nickName: HoshiTextField!
    @IBOutlet weak var userAvatar: UIImageView!
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
        btn.animate(1, completion: { [weak self] () -> () in
            // save user info to server
            guard let name = self?.nickName.text else {return}
            guard let image = self?.userAvatar.image else {return}
            guard let currentUid = YjiFirebaseAuth.sharedInstance.currentUid else {return}
            let storagePath = "images/" + "\(currentUid)_profile.png"
            YjiFirebaseStorage.sharedInstance.uploadImage(image: image, toPath: storagePath)
            let userInfo = [currentUid : ["userName" : name, "avatarPath" : "storagePath"]]
            YjiFirebaseRTDB.sharedInstance.update(path: "users", value: userInfo)
            let secondVC = UIViewController()
            secondVC.transitioningDelegate = self
            self?.present(secondVC, animated: true, completion: nil)
        })
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
