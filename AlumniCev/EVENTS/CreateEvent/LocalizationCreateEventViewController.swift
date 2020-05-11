//
//  LocalizationCreateEventViewController.swift
//  AlumniCev
//
//  Created by alumnos on 24/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import CPAlertViewController
import MapKit
import SwiftSpinner

class LocalizationCreateEventViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var addLocalizationLbl: UILabel!
    
    @IBOutlet weak var optionalLB: UILabel!
    @IBOutlet weak var localizationTxF: UITextField!
    
    @IBOutlet weak var addressLbl: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    
    var lat:Float?
    var lon:Float?
    
    @IBOutlet weak var searchBtn: UIButton!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var createEventBtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addLocalizationLbl.text = "tooLocalization".localized()
        
        addBtn.setTitle("add".localized(), for: .normal)
        deleteBtn.setTitle("delete".localized(), for: .normal)
        searchBtn.setTitle("search".localized(), for: .normal)
        createEventBtn.setTitle("createEvent".localized(), for: .normal)
        optionalLB.text = "optional".localized()
        
        addressLbl.isHidden = true
        map.isHidden = true
        deleteBtn.isHidden = true
        addBtn.isHidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    // MARK:- Events Create Alerts
    
    /**
    This function creates the alerts when some field of the events is missing or fails.
    
    : conditions: it is important to take into account the following factors:
    * Verify that everything is fine
    
    : param:
    : returns:
    */
    
    @IBAction func createEventAction(_ sender: Any) {
        
        let alert = CPAlertViewController()
        
        if eventCreated!.idTypeEvent == nil{
            
            alert.showError(title: "Faltan datos", message: "Falta selecciona el tipo de evento" , buttonTitle: "OK", action: {(nil) in
                (self.parent as! CreateEventPageViewController).goNextPage(fowardTo: 0)
            })
            
            return
        }
        
        if eventCreated!.idsGroups.count == 0{
            
            alert.showError(title: "Faltan datos", message: "Falta seleccionar los grupos" , buttonTitle: "OK", action: {(nil) in
                (self.parent as! CreateEventPageViewController).goNextPage(fowardTo: 1)
            })
            return
        }
        
        if eventCreated?.titleEvent == nil{
            
            alert.showError(title: "Faltan datos", message: "Es necesario el título del evento" , buttonTitle: "OK", action: {(nil) in
                (self.parent as! CreateEventPageViewController).goNextPage(fowardTo: 2)
            })
            return
        }
        
        if (eventCreated?.titleEvent?.count)! > 100{
            
            alert.showError(title: "Exceso caracteres", message: "El título es demasiado largo" , buttonTitle: "OK", action: {(nil) in
                (self.parent as! CreateEventPageViewController).goNextPage(fowardTo: 3)
            })
            return
        }
        
        if (eventCreated?.descriptionEvent?.count)! > 2500{
            alert.showError(title: "Exceso caracteres", message: "La descripción es demasiado larga" , buttonTitle: "OK", action: {(nil) in
                (self.parent as! CreateEventPageViewController).goNextPage(fowardTo: 3)
            })
            return
        }
        
        if eventCreated?.descriptionEvent == nil{
            alert.showError(title: "Faltan datos", message: "Es necesaria la descripción del evento" , buttonTitle: "OK", action: {(nil) in
                (self.parent as! CreateEventPageViewController).goNextPage(fowardTo: 3)
            })
            return
        }
        
        var image:Data?
        var url:String?
        
        if eventCreated!.imageEvent != nil{
            image = eventCreated?.imageEvent
        }else{
            image = nil
        }
        
        if eventCreated!.url != nil{
            url = eventCreated!.url
        }else{
            url = nil
        }

        if(eventCreated?.lat == nil && eventCreated?.lon == nil){
            SwiftSpinner.show("...")
            
            createEventRequest(title: eventCreated!.titleEvent!, description: eventCreated!.descriptionEvent!, idType: eventCreated!.idTypeEvent!, idGroup: eventCreated!.idsGroups, controller: self,lat: nil, lon: nil, image: image, urlEvent: url)
            
            
        }else{
            SwiftSpinner.show("...")
            
            createEventRequest(title: eventCreated!.titleEvent!, description: eventCreated!.descriptionEvent!, idType: eventCreated!.idTypeEvent!, idGroup: eventCreated!.idsGroups, controller: self, lat: eventCreated!.lat!, lon: (eventCreated?.lon)!, image: image, urlEvent: url)
        }

    }
    
    
    
    
    
    // MARK:- Receive Address
    
    /**
    This function receives the location of a user at a certain point.
    : conditions: it is important to take into account the following factors:
    * Verify that everything is fine
    
    : param: lon, lat
    : returns:
    */
    
    func receiveAddress(addressReceived:Address){
        
        self.lat = addressReceived.lat
        self.lon = addressReceived.lon
        
        addressLbl.text = addressReceived.formatted_address
        
        let latitude:CLLocationDegrees = CLLocationDegrees((addressReceived.lat)!)
        let longitude:CLLocationDegrees = CLLocationDegrees((addressReceived.lon)!)
        
        let latDelta:CLLocationDegrees = 0.01
        let longDelta:CLLocationDegrees = 0.01
        
        let span:MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegion.init(center: location, span: span)
        
        map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = addressReceived.formatted_address
        
        map.addAnnotation(annotation)
        
        addressLbl.isHidden = false
        map.isHidden = false
        deleteBtn.isHidden = false
        addBtn.isHidden = false
    }
    
    
    

    
    
    /**
    We check if the field is complete, and if it is, we make the request
    : conditions: it is important to take into account the following factors:
    * Verify that everything is fine
    
    : param:
    : returns:
    */
    
    @IBAction func searchAction(_ sender: Any) {
        
        if(localizationTxF.text != ""){
            requestAddress(address: localizationTxF.text!, controller: self)
        }else{
            let alert = CPAlertViewController()
            alert.showError(title: "Error", message: "Debes introducir la dirección" , buttonTitle: "OK")
        }
 
    }
    
    
    
    

    
    /**
    Verification that the location has been added to the event
    : conditions: it is important to take into account the following factors:
    * Verify that everything is fine
    
    : param:
    : returns:
    */
    
    @IBAction func addUbication(_ sender: Any) {
        eventCreated?.lat = self.lat
        eventCreated?.lon = self.lon
        
        var alert = CPAlertViewController()
        
        alert.showSuccess(title: "Ubicación agregada", message: "Localización añadida al evento" , buttonTitle: "OK")
    }
    
    
    
    
    
    // MARK:- Clear Location
    
    /**
    We eliminate the location of an event
    : conditions: it is important to take into account the following factors:
    * Verify that everything is fine
    
    : param:
    : returns:
    */
    @IBAction func deleteAction(_ sender: Any) {

        let alert = CPAlertViewController()
        alert.showError(title: "Delet Localicaton", message: "Se va a eliminar la localización, ¿estas seguro?" , buttonTitle: "OK",action: { (nil) in
            eventCreated?.lat = nil
            eventCreated?.lon = nil
            
            self.lat = nil
            self.lon = nil
            
            self.addressLbl.isHidden = true
            self.deleteBtn.isHidden = true
            self.addBtn.isHidden = true
            self.map.isHidden = true
            self.localizationTxF.text = ""
        })
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    // MARK: - Create Alerts
    
    /**
    Function to create alerts in our application
    : conditions: it is important to take into account the following factors:
    * Verify that everything is fine
    
    : param:
    : returns:
    */
    
    func createAlert(type:String, title:String, message:String){
        let alert = CPAlertViewController()
        
        SwiftSpinner.hide()
        
        if type == "success"{
            alert.showSuccess(title: title, message: message , buttonTitle: "OK") { (nil) in
                self.dismiss(animated: true, completion: nil)
            }
        }else{
            alert.showError(title: title, message: message , buttonTitle: "OK")
            
        }
        
    }
    
   //We use this function to hide the keyboard when you press out of it
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
