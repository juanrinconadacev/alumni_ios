//
//  myAppTools.swift
//  AlumniCev
//
//  Created by alumnos on 9/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import Foundation
import UIKit

var userRegistered:[String:String] = [:]
let defaults = UserDefaults.standard

var eventCreated:Event?

let cevColor:UIColor = hexStringToUIColor(hex:"008D9D")

var groups:[Dictionary<String,Any>] = []

var types:[Dictionary<String,String>] = []

var requests:[Dictionary<String,Any>]?

var addressResponse:Dictionary<String,Any>?

var comments:[Dictionary<String,Any>]?

var users:[Dictionary<String,Any>]?

var user:Dictionary<String,Any>?

var friend:Dictionary<String,Any>?

var privacityUser:Dictionary<String,String>?

var globalidReceived:Int?

var events:[[String:Any]] = [

]

func saveDataInUserDefaults(value:String, key:String){
    
    if defaults.object(forKey: "userRegistered") == nil {
        defaults.set(userRegistered, forKey: "userRegistered")
    }
    userRegistered = defaults.object(forKey: "userRegistered") as! [String:String]
    userRegistered.updateValue(value, forKey: key)
    
    defaults.set(userRegistered, forKey: "userRegistered")
    defaults.synchronize()
    
}

func getDataInUserDefaults(key:String) -> String?{
    
    if defaults.object(forKey: "userRegistered") != nil{
        userRegistered = defaults.object(forKey: "userRegistered") as! [String:String]
        
        return userRegistered[key]
    }else{
        return nil
    }
    
}

func clearDataInUserDefaults(key:String){
    
    if defaults.object(forKey: "userRegistered") != nil {
        userRegistered = defaults.object(forKey: "userRegistered") as! [String : String]
        userRegistered.removeValue(forKey: key)
        
        defaults.set(userRegistered, forKey: "userRegistered")
        defaults.synchronize()
    }
    
}

func clearUserDefaults(){
    defaults.set(nil, forKey: "userRegistered")
    defaults.synchronize()
}


func isValidEmail(YourEMailAddress: String) -> Bool {
    let REGEX: String
    REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: YourEMailAddress)
}

func validateUrl (urlString: String?) -> Bool {
    let urlRegEx = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
    return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: urlString)
}

func isValidPhone(phone: String) -> Bool {
    
    return NSPredicate(format: "SELF MATCHES %@", "\\d{9}").evaluate(with: phone)
    
}
let URL_GENERAL = "http://h2744356.stratoserver.net/solfamidas/alumniCEV/public/index.php/"

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
