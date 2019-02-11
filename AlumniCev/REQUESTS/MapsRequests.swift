//
//  MapsRequests.swift
//  AlumniCev
//
//  Created by Daniel Plata on 28/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

func requestAddress(address:String, controller:UIViewController){
    let url = URL(string:"https://maps.googleapis.com/maps/api/geocode/json")
    
    let KEY = "AIzaSyC6rLqRQSs796sVeVvkeG--nFTSNaGmsks"
    
    let parameters: Parameters = ["key":KEY, "address": address]

    
    let headers: HTTPHeaders = [
        "Accept": "application/json"
    ]
    
    Alamofire.request(url!, method: .get, parameters: parameters, headers: headers).responseJSON{response in
        
        if (response.result.value != nil){
        
            var arrayResult = response.result.value as! Dictionary<String, Any>
            
            switch response.result {
            case .success:
                switch arrayResult["status"] as! String{
                case "OK":
                    addressResponse = (arrayResult["results"] as! [Any])[0] as? Dictionary<String, Any>
                    
                    let newAddress = Address()
                    newAddress.formatted_address = addressResponse!["formatted_address"] as? String
                    newAddress.lat =
                        ((addressResponse!["geometry"] as! Dictionary<String, Any>)["location"] as! Dictionary<String, Any>)["lat"] as? Float
                    
                    newAddress.lon =
                        ((addressResponse!["geometry"] as! Dictionary<String, Any>)["location"] as! Dictionary<String, Any>)["lng"] as? Float
                    
                    (controller as! LocalizationCreateEventViewController).receiveAddress(addressReceived: newAddress)
                    
                case "ZERO_RESULTS":
                    print("No hay resultados")
                    
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
    
    func addressFromPosition(lat:Float, lon: Float, controller:UIViewController){
        let url = URL(string:"https://maps.googleapis.com/maps/api/geocode/json")
        
        let KEY = "AIzaSyC6rLqRQSs796sVeVvkeG--nFTSNaGmsks"
        
        let parameters: Parameters = ["key":KEY, "latlng": lat.description + "," + lon.description]
        
        
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        Alamofire.request(url!, method: .get, parameters: parameters, headers: headers).responseJSON{response in
            
            if (response.result.value != nil){
            
                var arrayResult = response.result.value as! Dictionary<String, Any>
                
                switch response.result {
                case .success:
                    switch arrayResult["status"] as! String{
                    case "OK":
                        addressResponse = (arrayResult["results"] as! [Any])[0] as? Dictionary<String, Any>
                        
                        let newAddress = Address()
                        newAddress.formatted_address = addressResponse!["formatted_address"] as? String
                        newAddress.lat =
                            ((addressResponse!["geometry"] as! Dictionary<String, Any>)["location"] as! Dictionary<String, Any>)["lat"] as? Float
                        
                        newAddress.lon =
                            ((addressResponse!["geometry"] as! Dictionary<String, Any>)["location"] as! Dictionary<String, Any>)["lng"] as? Float

                        (controller as! DetailEventViewController).setEvent(address: newAddress)
                        
                    case "ZERO_RESULTS":
                        print("No hay resultados")
                        
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
