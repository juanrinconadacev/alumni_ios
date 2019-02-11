//
//  ProfileRequests.swift
//  AlumniCev
//
//  Created by alumnos on 9/2/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import Foundation
import Alamofire

func requestProfile(){
    let user = URL(string: URL_GENERAL + "users/userbyid.json")
    let id = getDataInUserDefaults(key:"id")
    let token = getDataInUserDefaults(key:"token")
    
    let parameters: Parameters = ["id": Int(id!)!]
    
    let headers: HTTPHeaders = [
        "Authorization": token!,
        "Accept": "application/json"
    ]
    
    Alamofire.request(user!, method: .get, parameters: parameters, headers: headers).responseJSON{response in
        
        if (response.result.value != nil){
        
            var arrayResult = response.result.value as! Dictionary<String, Any>
            
            switch response.result {
            case .success:
                switch arrayResult["code"] as! Int{
                case 200:
                    print(arrayResult)
                    
                    break
                default:
                    print(arrayResult["message"] as! String)
                }
            case .failure:
                
                print("Error :: \(String(describing: response.error))")
                
            }
            
        } 
            
    }
}

