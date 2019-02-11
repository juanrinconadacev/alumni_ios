//
//  TipeEventViewController.swift
//  AlumniCev
//
//  Created by alumnos on 24/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit

class TipeEventViewController: UIViewController{
    
    @IBOutlet weak var typeLbl: UILabel!

    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        typeLbl.text = "typeEvent".localized()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        eventCreated?.idTypeEvent = nil
    }
    
    @IBAction func selecTypeAction(_ sender: Any) {
        
        eventCreated?.idTypeEvent = (sender as! UIButton).tag
        print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
        print(eventCreated?.idTypeEvent!)
        
        (parent as! CreateEventPageViewController).goNextPage(fowardTo: 1)
        
    }

}
