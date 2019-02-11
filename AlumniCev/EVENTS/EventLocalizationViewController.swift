//
//  EventLocalizationViewController.swift
//  AlumniCev
//
//  Created by Daniel Plata on 23/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import MapKit


class EventLocalizationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    var lat:Float = 0.0
    var lon:Float = 0.0
    
    var titleEvent:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let latitude:CLLocationDegrees = CLLocationDegrees(lat)
        let longitude:CLLocationDegrees = CLLocationDegrees(lon)
        
        let latDelta:CLLocationDegrees = 0.01
        let longDelta:CLLocationDegrees = 0.01

        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = titleEvent
//        annotation.subtitle = "Esto es una prueba"
        
        map.addAnnotation(annotation)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
