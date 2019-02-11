//
//  chatRequests.swift
//  AlumniCev
//
//  Created by raul on 13/3/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import Foundation
import Alamofire

func messagesRequest(id_chat:String?, action: @escaping (_ messages:[Dictionary<String,Any>]?)->()){
    
    let url = URL(string: URL_GENERAL + "chat/messages.json")
    let parameters: Parameters = ["id_chat":id_chat!]
    let token = getDataInUserDefaults(key:"token")
    let headers: HTTPHeaders = [
        "Authorization": token!,
        "Accept": "application/json"
    ]
    
    Alamofire.request(url!, method: .get, parameters: parameters, headers: headers).responseJSON{response in
        if (response.result.value != nil){
            var arrayResult = response.result.value as! Dictionary<String, Any>
            switch response.result {
            case .success:
                
                switch arrayResult["code"] as! Int{
                    
                case 200:
                    let arrayData = arrayResult["data"]! as? Dictionary<String,Any>
                    action(arrayData?["messages"] as! [Dictionary<String, Any>])
                default:
                    
                    break
                    
                }
            case .failure:
                
                print("Error :: \(String(describing: response.error))")
            }
        }
    }
}

func sendMessageRequest(id_chat:String,description:String, action: @escaping (_ message:String)->()){
    
    let url = URL(string: URL_GENERAL + "chat/sendMessage.json")
    let parameters: Parameters = ["id_chat":id_chat,"description":description]
    let token = getDataInUserDefaults(key:"token")
    let headers: HTTPHeaders = [
        "Authorization": token!,
        "Accept": "application/json"
    ]
    
    Alamofire.request(url!, method: .post, parameters: parameters, headers: headers).responseJSON{response in
        
        if (response.result.value != nil){
            var arrayResult = response.result.value as! Dictionary<String, Any>
            switch response.result {
            case .success:
                action(arrayResult["message"] as! String)
            case .failure:
                action(String(describing: response.error))
            }
            
           
        }
    }
}

func getUsersToChat(action: @escaping (_ messages:[Dictionary<String,Any>]?)->()){
    
    let url = URL(string: URL_GENERAL + "chat/userstochat.json")
//    let parameters: Parameters = ["id_chat":id_chat]
    let token = getDataInUserDefaults(key:"token")
    let headers: HTTPHeaders = [
        "Authorization": token!,
        "Accept": "application/json"
    ]
    
    Alamofire.request(url!, method: .get, headers: headers).responseJSON{response in
        
        if (response.result.value != nil){
            var arrayResult = response.result.value as! Dictionary<String, Any>
            switch response.result {
            case .success:
                
                switch arrayResult["code"] as! Int{
                    
                case 200:
                    
                    let arrayData = arrayResult["data"]! as? Dictionary<String,Any>

                    if arrayData != nil {
                        action(arrayData?["users"] as? [Dictionary<String, Any>])
                    }else{
                        action(nil)
                    }
                    // alert no hay amigos con los que iniciar un chat nuevo
                    
                default:
                    
                    break
                    
                }
            case .failure:
                
                print("Error :: \(String(describing: response.error))")
            }
        }
    }
}

func createChatRequesst(id_user:String, action: @escaping (_ message:Dictionary<String,Any>)->()){
    
    let url = URL(string: URL_GENERAL + "chat/create.json")
    let parameters: Parameters = ["id_user":id_user]
    let token = getDataInUserDefaults(key:"token")
    let headers: HTTPHeaders = [
        "Authorization": token!,
        "Accept": "application/json"
    ]
    
    Alamofire.request(url!, method: .post, parameters: parameters, headers: headers).responseJSON{response in
        
        if (response.result.value != nil){
            var arrayResult = response.result.value as! Dictionary<String, Any>
            switch response.result {
            case .success:

                let arrayData = arrayResult["data"]! as? Dictionary<String,Any>

                action(arrayData?["chat"] as! Dictionary<String, Any>)
            case .failure:
                break
            }
            
            
        }
    }
}

func getChatsRequest(action: @escaping (_ messages:[Dictionary<String,Any>]?)->()){
    
    let url = URL(string: URL_GENERAL + "chat/chats.json")
    let token = getDataInUserDefaults(key:"token")
    let headers: HTTPHeaders = [
        "Authorization": token!,
        "Accept": "application/json"
    ]
    
    Alamofire.request(url!, method: .get, headers: headers).responseJSON{response in
        
        if (response.result.value != nil){
            var arrayResult = response.result.value as! Dictionary<String, Any>
            switch response.result {
            case .success:
                
                switch arrayResult["code"] as! Int{
                    
                case 200:
                    
                    let arrayData = arrayResult["data"]! as? Dictionary<String,Any>
                    //print(arrayData)
                    if arrayData != nil {
                        print(arrayData)
                        action(arrayData?["chats"] as? [Dictionary<String, Any>])
                    }else{
                        action(nil)
                    }

                    
                default:
                    
                    break
                    
                }
            case .failure:
                
                print("Error :: \(String(describing: response.error))")
            }
        }
    }
}
