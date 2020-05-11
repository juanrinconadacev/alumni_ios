//
//  ForgotViewController.swift
//  AlumniCev
//
//  Created by alumnos on 17/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import CPAlertViewController
import Alamofire
import SwiftSpinner

class ForgotViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Confirmar email".localized()
        updateTexts()
        // Do any additional setup after loading the view.
    }
    
    
    
    /**
     This function allows you to change the style of different elements.
     
     : conditions: It is important to take into account the following factors:
     * Each element has its unique properties
     
     : param:
     : returns:
     */
    
    func updateTexts()
    {

        sendButton.layer.borderColor = UIColor.white.cgColor
        sendButton.layer.borderWidth = 2
        sendButton.layer.cornerRadius = sendButton.layer.frame.height / 2
       
        sendButton.setTitle("ok".localized(), for: .normal)
        emailTextField.placeholder = "email".localized()
        
    }
    
    
    
    /**
     This function allows you to change the style of different elements.
         
     : conditions: It is important to take into account the following factors:
                                                                             * Each element has its unique properties
         
     : param: textfield
     : returns:
     */
    
    func styleTxF(textfield:UITextField){
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: textfield.frame.size.height - width, width:  textfield.frame.size.width, height: textfield.frame.size.height)
        
        border.borderWidth = width
        textfield.layer.addSublayer(border)
        textfield.layer.masksToBounds = true
        
        textfield.setValue(UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5), forKeyPath: "_placeholderLabel.textColor")
        
    }
    
    override func viewDidLayoutSubviews(){
        styleTxF(textfield:emailTextField)
        
    }
    
    
    // MARK:- Email Action
    
    /**
    This function allows you to check if the email account is correct and is previously registered.
    
    : conditions: it is important to take into account the following factors:
    * All fields must be correct
    * The email must be entered
    *
    
    : param: email
    : returns:
    */
    
    @IBAction func ActionCheckEmail(_ sender: Any) {
        
        let alert = CPAlertViewController()
        
        if emailTextField.text != ""{
        
            if isValidEmail(YourEMailAddress: emailTextField.text!){
                let url = URL(string: URL_GENERAL + "users/validateEmail.json")
                
                let parameters : Parameters = ["email":emailTextField.text!]
                
                SwiftSpinner.show("...")
                
                AF.request(url!, method: .get, parameters: parameters).responseJSON{response in
                    
                    var arrayResult = response.result.value as! Dictionary<String, Any>
                    let alert = CPAlertViewController()
                    
                    switch response.result {
                    case .success:
                        switch arrayResult["code"] as! Int{
                        case 200:
                            
                            SwiftSpinner.hide()
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RecoverViewController") as! RecoverViewController
                            //vc.modalTransitionStyle = .flipHorizontal
                            var arrayData = arrayResult["data"] as! Dictionary<String,Any>
                            vc.id =  Int( arrayData["id"] as! String)
                            self.navigationController?.pushViewController(vc, animated: true)
                            //self.present(vc, animated: true)
                            
                        default:
                            SwiftSpinner.hide()
                            
                            alert.showError(title: (arrayResult["message"] as! String), buttonTitle: "OK")
                        }
                    case .failure:
                        SwiftSpinner.hide()
                        print("Error :: \(String(describing: response.error))")
                    }
                    
                }
            }else{
                alert.showError(title: "wrongEmail".localized(), buttonTitle: "OK")
            }
            
        }else{
            alert.showError(title: "allFieldsRequired".localized(), buttonTitle: "OK")
        }
    }
    @IBAction func dismissFunction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

    
    
    //We use this function to hide the keyboard when you press out of it
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
