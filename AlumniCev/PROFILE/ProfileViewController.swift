//
//  ProfileViewController.swift
//  AlumniCev
//
//  Created by Daniel Plata on 22/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!

    @IBOutlet weak var usernameLbl: UILabel!

    @IBOutlet weak var descriptionTxV: UITextView!
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    @IBOutlet weak var phonePrivacityLbl: UILabel!
    @IBOutlet weak var localizationPrivacityLbl: UILabel!
    
    @IBOutlet weak var shareLocalizationLbl: UILabel!
    @IBOutlet weak var sharePhoneLbl: UILabel!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgProfile.contentMode = .scaleAspectFill
        imgProfile.layer.masksToBounds = true

        logoutBtn.layer.cornerRadius = logoutBtn.layer.frame.height / 2
        
        shareLocalizationLbl.text = "localizSettings".localized()
        sharePhoneLbl.text = "phoneSettings".localized()
        
        
        //editBtn.setTitle("edit".localized(), for: .normal)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        setValues()
        cheeckPrivacity()
    }
    
    
    
    
    
    
    
    
    // MARK:- User Privacy
    
    /**
    We personalize the user's privacy.
    : conditions:
    
    : param: phonePrivacity, localizationPrivacity
    : returns:
    */
    
    func cheeckPrivacity(){
        let phonePrivacity = getDataInUserDefaults(key: "phoneprivacity") == "1" ? "yes".localized() : "no".localized()
        phonePrivacityLbl.text = phonePrivacity
        
        let localizationPrivacity = getDataInUserDefaults(key: "localizationprivacity") == "1" ? "yes".localized() : "no".localized()
        localizationPrivacityLbl.text = localizationPrivacity
        
    }

    
    
    
    
    
    /**
    We collect our user's data
    : conditions:
    
    : param:name, username, description
    : returns:
    */
    
    func setValues(){
        
        let name = getDataInUserDefaults(key: "name")
        nameLbl.text = name
        
        let username = getDataInUserDefaults(key: "username")
        usernameLbl.text = username

        if getDataInUserDefaults(key: "description") == nil{
            descriptionTxV.text = "defaulDesc".localized()
        }else{
            descriptionTxV.text = getDataInUserDefaults(key: "description")
        }
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getPhoto()
    }
    
    
    
    
    // MARK:- Photo User
    
    /**
    We collect the images of our user
    : conditions:
    
    : param: photo
    : returns:
    */
    func getPhoto(){
        
        if getDataInUserDefaults(key: "photo") != nil{
            imgProfile.image = UIImage(data: Data(base64Encoded: getDataInUserDefaults(key: "photo")!)!)
        }else{
            imgProfile.image = #imageLiteral(resourceName: "userdefaulticon")
        }
        
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height/2
        imgProfile.layer.masksToBounds = true
        imgProfile.layer.borderColor = UIColor( red: 1, green: 1, blue:1, alpha: 1.0 ).cgColor
        imgProfile.layer.borderWidth = 2
    
    }
    
    
    
    
    
    //Instance the settings screen
    
    @IBAction func goToSettings(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }


    
    
    //Logout
    
    @IBAction func logoutAction(_ sender: UIButton) {
        clearUserDefaults()
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        
    }

}
