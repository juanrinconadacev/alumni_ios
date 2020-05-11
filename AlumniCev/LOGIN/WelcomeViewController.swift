//
//  WelcomeViewController.swift
//  AlumniCev
//
//  Created by alumnos on 8/2/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import Photos
import CPAlertViewController


class WelcomeViewController: UIViewController, UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate  {

    @IBOutlet weak var titleWelcolmeLB: UILabel!
    @IBOutlet weak var alwaysChangeLb: UILabel!    
    @IBOutlet weak var changeProfileLb: UILabel!
    @IBOutlet weak var newProfileImage: UIImageView!
    @IBOutlet weak var changePhotoBtn: UIButton!
    @IBOutlet weak var notChangeBtn: UIButton!
    
    var changePhoto = false
    
    var picker:UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker = UIImagePickerController()
        picker?.delegate = self
        
        titleWelcolmeLB.text = "welcome".localized()
        alwaysChangeLb.text = "alwaysChange".localized()
        changeProfileLb.text = "changePhoto".localized()
        changePhotoBtn.setTitle("changeButton".localized(), for: .normal)
        notChangeBtn.setTitle("notchangeBtn".localized(), for: .normal)
        
        changePhotoBtn.layer.cornerRadius = changePhotoBtn.frame.size.width / 8
        changePhotoBtn.layer.masksToBounds = true
        
        notChangeBtn.layer.cornerRadius = notChangeBtn.frame.size.width / 8
        notChangeBtn.layer.masksToBounds = true
        notChangeBtn.layer.borderColor = cevColor.cgColor
        notChangeBtn.layer.borderWidth = 2
        
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK:- Gallery Request
    
    /**
    This function allows the Request to choose a photo from the gallery.
    
    : conditions: it is important to take into account the following factors:
    * Authorize permits
    
    : param:
    : returns:
    */
    
    func requestAuth(){
        PHPhotoLibrary.requestAuthorization({
            (newStatus) in print("new status is \(newStatus)")
            
            if newStatus == PHAuthorizationStatus.authorized {
                
                self.openGallary()
                
                print("success")
                
            }else{
                self.needAcceptPermission()
            }
        })
    }
    
    
    
 
    
    /**
    This function allows to authorize the permission of the gallery.
    
    : conditions: it is important to take into account the following factors:
    * Authorize permits
    
    : param:
    : returns:
    */
    func checkPermission() {
        
        requestAuth()
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        print(photoAuthorizationStatus)
        
        switch photoAuthorizationStatus {
            
        case .authorized:
            print("Access is granted by user")
            self.openGallary()
        case .notDetermined:
            print("Access is not determined")
            
        case .restricted:
            print("Access is restricted")
            
        case .denied:
            print("Access is denied")
            
        }
    }
    func openGallary()
    {
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(picker!, animated: true, completion: nil)
    }
    
    

    
    /**
    This function shows an alert in the case that we do not have authorized to show the gallery.
    
    : conditions: it is important to take into account the following factors:
    * Authorize permits
    
    : param:
    : returns:
    */
    
    func needAcceptPermission(){
        let alert = CPAlertViewController()
        alert.showError(title: "Es necesario aceptar los permisos desde ajustes", buttonTitle: "OK")
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK:- Picker
    
    /**
    This function creates a picker where we can choose a photo from our gallery.
    : terms:
    : param:
    : returns:
    */
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let chosenImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        newProfileImage.contentMode = .scaleAspectFit
        newProfileImage.image = chosenImage
        
        let photo:Data = chosenImage.jpegData(compressionQuality: 0.1)!
        
        saveDataInUserDefaults(value: photo.base64EncodedString(), key: "photo")
        
        let id = Int(getDataInUserDefaults(key: "id")!)
        
        requestEditUser(id: id!, email: nil, name: nil, phone: nil, birthday: nil, description: nil, photo: photo, phoneprivacity: 0, localizationprivacity: 0, action: {
            self.goToMain()
        }, fail: {
            
        })
        
        dismiss(animated: true, completion: nil)
        
    }

    @IBAction func changeMyPhoto(_ sender: Any) {
        
        checkPermission()
        
    }
    
    @IBAction func NotChangePhoto(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UITabBarController") as! UITabBarController
        vc.modalTransitionStyle = .flipHorizontal
        self.present(vc, animated: true)
        
    }
    
    
    /**
     This function takes us to the Tab bar Controller screen.
     
     : conditions: it is important to take into account the following factors:
     * Unique identifier
     
     : param:
     : returns:
     */
    
    func goToMain(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UITabBarController") as! UITabBarController
        vc.modalTransitionStyle = .flipHorizontal
        self.present(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
