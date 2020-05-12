 //
 //  RegisterViewController.swift
 //  AlumniCev
 //
 //  Created by alumnos on 9/1/18.
 //  Copyright © 2018 Victor Serrano. All rights reserved.
 //
 
 import UIKit
 import Alamofire
 import CPAlertViewController
 import SwiftSpinner
 import JHTAlertController

 import CoreLocation
 
 class RegisterViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    
    var lon:Float = 0.0
    var lat:Float = 0.0
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Registro"
        manager.delegate = self
        
        // Do any additional setup after loading the view.
        updateTexts()
    }
    
    
    /**
     This function allows you to change the style of different elements.
     
     : conditions: It is important to take into account the following factors:
     * Each element has its unique properties
     
     : param:
     : returns:
     */
    
    func updateTexts(){

        emailTextField.placeholder = "email".localized()
        passwordTextField.placeholder = "password".localized()
        repeatPasswordTextField.placeholder = "repeatPassword".localized()
        btnRegister.setTitle("register".localized(), for: .normal)
        
        
        btnRegister.layer.borderColor = UIColor.white.cgColor
        btnRegister.layer.borderWidth = 2
        btnRegister.layer.cornerRadius = btnRegister.layer.frame.height / 2

        
        //Set color placeholder blanco
        passwordTextField.setValue(UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5), forKeyPath: "_placeholderLabel.textColor")
        repeatPasswordTextField.setValue(UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5), forKeyPath: "_placeholderLabel.textColor")
        emailTextField.setValue(UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5), forKeyPath: "_placeholderLabel.textColor")
        
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
        styleTxF(textfield:passwordTextField)
        styleTxF(textfield:repeatPasswordTextField)
        styleTxF(textfield:emailTextField)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    // MARK:- Alerts Register
    
    /**
    This function creates alerts to warn us that a field has been entered incorrectly
    
    : conditions: it is important to take into account the following factors:
    * All fields must be correct
    
    : param: emitter button that performs the action
    : returns:
    */
    
    @IBAction func registerAction(_ sender: Any) {
        
        let alert = CPAlertViewController()
        
        if emailTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != ""{
        
            if isValidEmail(YourEMailAddress: emailTextField.text!) {

                if repeatPasswordTextField.text! == passwordTextField.text!{
                    
                    let password:String = passwordTextField.text!
                    
                    if password.count > 4 && password.count < 13{
                        self.createRegisterRequest(email: emailTextField.text!, password: passwordTextField.text!)
                    }else{
                        alert.showError(title: "lengthPassword".localized(), buttonTitle: "OK")
                    }
                    
                }
                else{
                    alert.showError(title: "wrongRepeatPassword".localized(), buttonTitle: "OK")
                }
                
            }else {
                alert.showError(title: "wrongEmail".localized(), buttonTitle: "OK")
            }
            
        }else{
            alert.showError(title: "allFieldsRequired".localized(), buttonTitle: "OK")
        }
    }
    
    
    // MARK:- Register Methods
    
    /**
    This function allows to perform the Request of a user's record
    
    : conditions: it is important to take into account the following factors:
    * All fields must be correct
    
    : param: email, password
    : returns:
    */
    
    func createRegisterRequest(email:String, password:String){
        
        //let url = URL(string: URL_GENERAL + "users/create.json")
        let url = "http://localhost:8888/alumniCEV-master/public/users/create.json"
        
        let parameters : Parameters = ["email":email,"password":password]
        
        SwiftSpinner.show("...")
        
        AF.request(url, method: .post, parameters: parameters).responseJSON{response in
            
            let arrayResult = response.value as! Dictionary<String, Any>
            let alert = CPAlertViewController()
            
            switch response.result {
            case .success:
                switch arrayResult["code"] as! Int{
                    case 200:

                        self.getLocation()
                    
                    default:
                        
                        SwiftSpinner.hide()
                        alert.showError(title: (arrayResult["message"] as! String), buttonTitle: "OK")
                }
            case .failure:
                SwiftSpinner.hide()
                print("Error :: \(String(describing: response.error))")
            }
            
        }
    }
    
    
    // MARK:- Login Request
    
    /**
     This function makes the Request of a user's Login.
     
     : conditions: it is important to take into account the following factors:
     * well-entered parameters
     * correct fields
     * url valida
     
     : param: email, password, lon, lat
     : returns:
     */
    func createLoginRequest(email:String, password:String){
        
        //let url = URL(string: URL_GENERAL + "users/login.json")
        let url = "http://localhost:8888/alumniCEV-master/public/users/login.json"
        
        let parameters: Parameters = ["email":email,"password":password, "lon": self.lon , "lat": self.lat]
        
        AF.request(url, method: .post, parameters: parameters).responseJSON{response in
            
            let arrayResult = response.value as! Dictionary<String, Any>
            let alert = CPAlertViewController()
            
            switch response.result {
            case .success:
                switch arrayResult["code"] as! Int{
                case 200:
                    let arrayData = arrayResult["data"] as! Dictionary<String,Any>
                    let arrayUser = arrayData["user"] as! Dictionary<String,Any>
                    let arrayPrivacity = arrayData["privacity"] as! Dictionary<String,String>
                    
                    SwiftSpinner.hide()
                    
                    // Setting up an alert with a title and message
                    let alertController = JHTAlertController(title: "", message: "Congratulations".localized(), preferredStyle: .alert)
                    
                    // Create an action with a completionl handler.
                    let okAction = JHTAlertAction(title: "OK", style: .default, bgColor: cevColor) { _ in
                        saveDataInUserDefaults(value: arrayUser["id"] as! String, key: "id")
                        saveDataInUserDefaults(value: arrayUser["id_rol"] as! String, key: "id_rol")
                        saveDataInUserDefaults(value: arrayUser["email"] as! String, key: "email")
                        saveDataInUserDefaults(value: arrayUser["password"] as! String, key: "password")
                        saveDataInUserDefaults(value: arrayUser["name"] as! String, key: "name")
                        saveDataInUserDefaults(value: arrayData["token"] as! String, key: "token")
                        saveDataInUserDefaults(value: arrayUser["username"] as! String, key: "username")
                        saveDataInUserDefaults(value: arrayPrivacity["localization"] as! String,key: "localizationprivacity")
                        
                        if !(arrayUser["description"] is NSNull)  {
                            saveDataInUserDefaults(value: arrayUser["description"]! as! String, key: "description")
                        }else{
                            clearDataInUserDefaults(key: "description")
                        }
                        
                        if !(arrayUser["phone"] is NSNull)  {
                            
                            saveDataInUserDefaults(value: arrayUser["phone"]! as! String, key: "phone")
                        }else{
                            clearDataInUserDefaults(key: "phone")
                        }
                        
                        
                        clearDataInUserDefaults(key: "photo")
                        
                        saveDataInUserDefaults(value: "true", key: "isLoged")
                        self.goToMain()
                    }
                    
                    alertController.addAction(okAction)
                    alertController.titleImage = UIImage(named: "Certificate")
                    alertController.titleViewBackgroundColor = UIColor.white
                    alertController.messageTextColor = cevColor
                    alertController.alertBackgroundColor = UIColor.white
                    
                    // Show the action
                    self.present(alertController, animated: true, completion: nil)
                    
                default:
                    SwiftSpinner.hide()
                    alert.showError(title: (arrayResult["message"] as! String), buttonTitle: "OK")
                }
            case .failure:
                SwiftSpinner.hide()
                print("Error :: \(String(describing: response.error))")
            }
            SwiftSpinner.hide()
        }
    }
    
    
    // MARK:- Location Methods
    
    /**
    This function allows to analyze the location of a specific user.
    
    : conditions: it is important to take into account the following factors:
    * All fields must be correct
    * Coordinate lon and lat
    
    : param: lon, lat
    : returns:
    */
    
    func getLocation(){
        
        manager.requestAlwaysAuthorization()
        manager.requestLocation()
        
        SwiftSpinner.show("...")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)")
            
            self.manager.stopUpdatingLocation()
            
            self.lon = Float(location.coordinate.longitude)
            self.lat = Float(location.coordinate.latitude)
            
            self.createLoginRequest(email: emailTextField.text!, password: passwordTextField.text!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        self.manager.stopUpdatingLocation()
        self.createLoginRequest(email: emailTextField.text!, password: passwordTextField.text!)
    }
    

    /**
     This function takes us to the Tab bar Controller screen.
     
     : conditions: it is important to take into account the following factors:
     * Unique identifier
     
     : param:
     : returns:
     */
    func goToMain(){
        
        let tabbarVC = storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        
        self.present(tabbarVC, animated: false, completion: nil)
        
    }
    
    //We use this function to hide the keyboard when you press out of it
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

 }
