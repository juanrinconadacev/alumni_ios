//
//  GroupsRequests.swift
//  AlumniCev
//
//  Created by alumnos on 26/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import Foundation
import Alamofire

func requestTypes(controller:UIViewController){
    //let url = URL(string: URL_GENERAL + "events/types.json")
    let url = "http://192.168.6.167/ProyectoAlumni/public/index.php/api/listtypes"

    let token = getDataInUserDefaults(key:"token")
    
    let headers: HTTPHeaders = [
        "Authorization": token!,
        "Accept": "application/json"
    ]
    
    AF.request(url, method: .get, headers: headers).responseJSON{response in
        
        if (response.value != nil){
        
            let arrayResult = response.value as! Dictionary<String, Any>
            print("Request Groups types")
            print(arrayResult)
            
            switch response.result {
            case .success:
                switch arrayResult["code"] as! Int{
                case 200:
                    types = arrayResult["data"] as! [Dictionary<String,String>]
                    
                default:
                    
                    print(arrayResult["message"] as! String)
                }
            case .failure:
                
                print("Error :: \(String(describing: response.error))")
                //alert.showError(title: (String(describing: response.error), buttonTitle: "OK")
            }
        }
    }
}

func requestGroups(action: @escaping ()->()){
   // let url = URL(string: URL_GENERAL + "groups/groups.json")
     let url = "http://192.168.6.167/ProyectoAlumni/public/index.php/api/listgroups"
    
    let token = getDataInUserDefaults(key:"token")
    
    let headers: HTTPHeaders = [
        "Authorization": token!,
        "Accept": "application/json"
    ]
    
    AF.request(url, method: .get, headers: headers).responseJSON{response in
        
        if (response.value != nil){
            
            var arrayResult = response.value as! Dictionary<String, Any>
            print("imprimiendo data")
            print(arrayResult["data"]!)
            var arrayData = arrayResult["data"]! as! Dictionary<String,Any>
            
            switch response.result {
            case .success:
                switch arrayResult["code"] as! Int{
                case 200:

                    
                    groups = arrayData["groups"] as! [Dictionary<String,Any>]
                    
                    action()
                    
                default:
                    
                    print(arrayResult["message"] as! String)
                }
            case .failure:
                
                print("Error :: \(String(describing: response.error))")
                //alert.showError(title: (String(describing: response.error), buttonTitle: "OK")
            }
        }
    }
}

func requestGroupsbyUser (action: @escaping ()->()){
    let url = URL(string: URL_GENERAL + "groups/groupsbyuser.json")
    
    let token = getDataInUserDefaults(key:"token")
    
    let headers: HTTPHeaders = [
        "Authorization": token!,
        "Accept": "application/json"
    ]
    
    AF.request(url!, method: .get, headers: headers).responseJSON{response in
        
        if (response.value != nil){
            
            var arrayResult = response.value as! Dictionary<String, Any>
            var arrayData = arrayResult["data"]! as! Dictionary<String,Any>
            
            switch response.result {
            case .success:
                switch arrayResult["code"] as! Int{
                case 200:
                    
                    groups = arrayData["groups"] as! [Dictionary<String,Any>]
                    action()
                default:
                    
                    print(arrayResult["message"] as! String)
                }
            case .failure:
                
                print("Error :: \(String(describing: response.error))")
                //alert.showError(title: (String(describing: response.error), buttonTitle: "OK")
            }
        }
    }
}
