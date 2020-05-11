//
//  SettingsViewController.swift
//  AlumniCev
//
//  Created by Daniel Plata on 8/2/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import Photos
import CPAlertViewController
import NVActivityIndicatorView

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var completView: UIView!
    
    @IBOutlet weak var spinner: NVActivityIndicatorView!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var nameTitleLbl: UILabel!
    @IBOutlet weak var nameTxF: UITextField!
    
    
    @IBOutlet weak var changePasswordBtn: UIButton!
    
    @IBOutlet weak var phoneTitleLbl: UILabel!
    @IBOutlet weak var phoneTxF: UITextField!
    
    @IBOutlet weak var emailTitleLbl: UILabel!
    @IBOutlet weak var emailTxF: UITextField!
    
    @IBOutlet weak var descriptionTitleLbl: UILabel!
    @IBOutlet weak var descriptionTxV: UITextView!
    
    @IBOutlet weak var privacityTitleLbl: UILabel!
    
    @IBOutlet weak var localizationTitleLbl: UILabel!
    @IBOutlet weak var switchLocalization: UISwitch!
    
    @IBOutlet weak var allowPhoneLbl: UILabel!
    @IBOutlet weak var switchPhone: UISwitch!
    
    @IBOutlet weak var changePhotoBtn: UIButton!
    
    
    var photo:Data?
    
    var picker:UIImagePickerController?
    
    var cpalert:CPAlertViewController? = nil
    
    var lastPassword:String?
    var password:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cpalert = CPAlertViewController()
        
        let phonePrivacity = getDataInUserDefaults(key: "phoneprivacity") == "1" ? true : false
        
        let localizationPrivacity = getDataInUserDefaults(key: "localizationprivacity") == "1" ? true : false
        
        switchPhone.setOn(phonePrivacity, animated: false)
        switchLocalization.setOn(localizationPrivacity, animated: false)
        
        imgProfile.contentMode = .scaleAspectFill
        imgProfile.layer.masksToBounds = true
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height/2
        

        
        setTitles()
        setValues()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    /**
     We collect our user's data
     : conditions:
     
     : param:name, phone, email, photo, description
     : returns:
     */
    
    func setValues(){
        let name = getDataInUserDefaults(key: "name")
        nameTxF.text = name
        
        if getDataInUserDefaults(key: "phone") != nil{
            let phone = getDataInUserDefaults(key: "phone")
            phoneTxF.text = phone
        }
        
        let email = getDataInUserDefaults(key: "email")
        emailTxF.text = email
        
        if getDataInUserDefaults(key: "photo") != nil{
            imgProfile.image = UIImage(data: Data(base64Encoded: getDataInUserDefaults(key: "photo")!)!)
        }
        
        if getDataInUserDefaults(key: "description") != nil{
            let description = getDataInUserDefaults(key: "description")
            descriptionTxV.text = description
        }else{
            descriptionTxV.text = "defaulDesc".localized()
        }
    }
    
    
    
    
    //Localized
    
    func setTitles(){
        changePhotoBtn.setTitle("changePhoto".localized(), for: .normal)
        nameTitleLbl.text = "fullName".localized()
        changePasswordBtn.setTitle("password".localized(), for: .normal)
        phoneTitleLbl.text = "MyPhone".localized()
        emailTitleLbl.text = "emailSettings".localized()
        descriptionTitleLbl.text = "descriptSettings".localized()
        localizationTitleLbl.text = "localizSettings".localized()
        allowPhoneLbl.text = "phoneSettings".localized()

    }
    
    
    
    
    
    // MARK:- Change Password
    /**
    this function is used to change the password of a user's account
    : conditions:
    
    : param:
    : returns:
    */
    @IBAction func changePasswordAction(_ sender: Any) {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "changePass".localized(), message: "change".localized(), preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "lessPass".localized()
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "newPass".localized()
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "repitPass".localized()
        }
        
        alert.addAction(UIAlertAction(title: "cancel".localized(), style: .destructive, handler: nil))
        
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textFieldAntigua = alert?.textFields![0]
            let textFieldNueva = alert?.textFields![1]
            let textFieldRepetirNueva = alert?.textFields![2]
            
            if textFieldAntigua!.text != "" && textFieldNueva!.text != "" && textFieldRepetirNueva!.text != ""{
                
                if textFieldNueva!.text != textFieldRepetirNueva!.text{
                    self.present(alert!, animated: true, completion: nil)
                    alert?.message = "wrongRepeatPassword".localized()
                    alert?.setValue(NSAttributedString(string: (alert?.message)!, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor : UIColor.red]), forKey: "attributedMessage")
                }else{
                    if (textFieldNueva!.text?.count)! < 5 || (textFieldNueva!.text?.count)! > 12{
                        self.present(alert!, animated: true, completion: nil)
                        alert?.message = "lengthPassword".localized()
                        alert?.setValue(NSAttributedString(string: (alert?.message)!, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor : UIColor.red]), forKey: "attributedMessage")
                    }else{
                        
                        self.lastPassword = (textFieldAntigua!.text)!
                        self.password = (textFieldNueva?.text)!
                        
                        self.changePassword(alert: alert!)
                    }
                }
                
            }else{
                self.present(alert!, animated: true, completion: nil)
                alert?.message = "allFieldsRequired".localized()
                alert?.setValue(NSAttributedString(string: (alert?.message)!, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor : UIColor.red]), forKey: "attributedMessage")
            }
            
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    // MARK:- Request Password
    
    /**
    We made the request to make the password change
    : conditions:
    
    : param:
    : returns:
    */
    func changePassword(alert:UIAlertController){
        requestChangePassword(lastPassword: self.lastPassword!, password: self.password!, action: {
            
            self.cpalert?.showSuccess(title: "alertExit".localized(), message: "passwordChanged".localized(), buttonTitle: "OK", action: nil)
            
        }, fail: {
            self.present(alert, animated: true, completion: nil)
            alert.message = "oldPass".localized()
            alert.setValue(NSAttributedString(string: (alert.message)!, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor : UIColor.red]), forKey: "attributedMessage")
        })
    }
    
    
    
    
    
    
    
    // Alert to use the camera or gallery
    
    @IBAction func uploadImageAction(_ sender: UIButton) {
      
        picker = UIImagePickerController()
        picker?.delegate = self
        let alert = UIAlertController(title: "Usar camara o galeria", message: "¿Quieres subir una foto desde la camara o desde la galeria?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camara", style: .default, handler: { (nil) in
            self.checkPermissionCamera()
        }))
        alert.addAction(UIAlertAction(title: "Galeria", style: .default, handler: { (nil) in
            self.checkPermissionGallery()
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { (nil) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func checkPermissionCamera() {
        
        //Gallery permissions
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            //Ask for permits
            DispatchQueue.main.async {
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted)  in
                    if granted {
                        self.openCamera()
                    }
                })
            }
        case .denied,.restricted:
            //Alert to go to settings
            let alert = UIAlertController(title: "Se necesitan permisos", message: "Se necesitan permisos para acceder a la galeria", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ir a ajustes", style: .default, handler: { (nil) in
                UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            
            present(alert, animated: true)
            
        case .authorized:
            //Open camera
            openCamera()
        }
    }
    func checkPermissionGallery() {
        
        //Permits for gallery
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            //Ask for permits
            DispatchQueue.main.async {
                PHPhotoLibrary.requestAuthorization({(newStatus) in
                    print(newStatus)
                    if newStatus == PHAuthorizationStatus.authorized {
                        self.openGallary()
                    }
                    
                })
            }
        case .denied,.restricted:
            //Alert to go to settings
            let alert = UIAlertController(title: "Se necesitan permisos", message: "Se necesitan permisos para acceder a la galeria", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Ir a ajustes", style: .destructive, handler: { (nil) in
                UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }))
            present(alert, animated: true)
            
        case .authorized:
            //Open gallery
            openGallary()
        }
        
        
    }
    func openCamera(){
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerController.SourceType.camera
        present(picker!, animated: true, completion: nil)
    }
    func openGallary()
    {
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(picker!, animated: true, completion: nil)
    }
    
    
    
    
    
    
    // MARK: - Image Picker
    /**
    
    // The controlling object that manages the image selector interface.
    : conditions:
    
    : param: picker
    : returns:
    */
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let chosenImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        imgProfile.contentMode = .scaleAspectFit
        imgProfile.image = chosenImage
        
        photo = chosenImage.jpegData(compressionQuality: 0.1)!
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    // MARK:- Save Change Profile
    /**
     
    // We save all profile information
    : conditions:

    : param: id
    : returns:
    */
    
    @IBAction func saveChanges(_ sender: Any) {
        
        let alert = CPAlertViewController()
        
        let id = Int(getDataInUserDefaults(key: "id")!)
        
        if isValidEmail(YourEMailAddress: emailTxF.text!) {
            
            let email = emailTxF.text!
            
            if isValidPhone(phone: phoneTxF.text!) || phoneTxF.text! == ""{
                
                self.startSpinner()
                
                let phone = phoneTxF.text!
                let description = descriptionTxV.text
                let name = nameTxF.text
                
                let localizationprivacity = switchLocalization.isOn ? 1 : 0
                let phoneprivacity = switchPhone.isOn ? 1 : 0
                
                requestEditUser(id: id!, email: email, name: name, phone: phone, birthday: nil, description: description, photo: photo, phoneprivacity: phoneprivacity, localizationprivacity: localizationprivacity, action: {
                    
                    self.stopSpinner()
                    
                    alert.showSuccess(title: "alertExit".localized(), message: "saveChangeAlert".localized(), buttonTitle: "OK", action: { (nil) in
                        
                        if self.photo != nil{
                            saveDataInUserDefaults(value: (self.photo?.base64EncodedString())!, key: "photo")
                        }
                        
                        saveDataInUserDefaults(value: email, key: "email")
                        saveDataInUserDefaults(value: phone, key: "phone")
                        saveDataInUserDefaults(value: description!, key: "description")
                        saveDataInUserDefaults(value: name!, key: "name")
                        saveDataInUserDefaults(value: localizationprivacity.description, key: "localizationprivacity")
                        saveDataInUserDefaults(value: phoneprivacity.description, key: "phoneprivacity")
                        
                        self.navigationController?.popViewController(animated: true)
                    })
                    
                }, fail: {
                    
                    alert.showError(title: "Error", message: "notChangesDone".localized(), buttonTitle: "Ok", action: nil)
                    
                })
                
                
            }else{
                alert.showError(title: "wrongTlf".localized(), buttonTitle: "OK")
            }
            
        }else{
            alert.showError(title: "wrongEmail".localized(), buttonTitle: "OK")
        }
        
    }
    
    
    //Start Spinner
    func startSpinner(){
        completView.isUserInteractionEnabled = false
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    
    
    //Stop Spinner
    func stopSpinner(){
        completView.isUserInteractionEnabled = true
        spinner.isHidden = true
        spinner.stopAnimating()
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
