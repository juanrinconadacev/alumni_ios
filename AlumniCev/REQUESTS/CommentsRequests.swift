//
//  CommentsRequests.swift
//  AlumniCev
//
//  Created by Daniel Plata on 8/2/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import Foundation
import Alamofire
import CPAlertViewController

func requestCreateComment(title:String, description:String, id_event:Int, action:@escaping ()->()){
    //let url = URL(string: URL_GENERAL + "comments/create.json")
    let url = "http://192.168.6.167/ProyectoAlumni/public/index.php/api/createcomment"
    let parameters: Parameters = ["title":title, "description":description, "id_event": id_event]
    
    let token = getDataInUserDefaults(key:"token")
    
    let headers: HTTPHeaders = [
        "Authorization": token!,
        "Accept": "application/json"
    ]
    
    AF.request(url, method: .post, parameters: parameters, headers: headers).responseJSON{response in
        
        if (response.value != nil){
            
            var arrayResult = response.value as! Dictionary<String, Any>
            switch response.result {
            case .success:
                switch arrayResult["code"] as! Int{
                case 200:
                    
                    action()
                    print("comentario creado")
                    
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

func requestDeleteComment(id_comment:Int, action:@escaping ()->()){
    let url = URL(string: URL_GENERAL + "comments/delete.json")
    
    let parameters: Parameters = ["id_comment": id_comment]
    
    let token = getDataInUserDefaults(key:"token")
    
    let headers: HTTPHeaders = [
        "Authorization": token!,
        "Accept": "application/json"
    ]
    
    AF.request(url!, method: .post, parameters: parameters, headers: headers).responseJSON{response in
        
        if (response.value != nil){
            
            var arrayResult = response.value as! Dictionary<String, Any>
            let alert = CPAlertViewController()
            switch response.result {
            case .success:
                switch arrayResult["code"] as! Int{
                case 200:
                    
                    alert.showSuccess(title: arrayResult["message"] as? String, buttonTitle: "ok" )
                    
                    action()
                    print("comentario borrado")
                    
                default:
                    print(arrayResult["message"] as! String)
                    alert.showError(title: arrayResult["message"] as? String, buttonTitle: "ok" )
                }
            case .failure:
                print("Error :: \(String(describing: response.error))")
            }
            
        }
    }
}
