//
//  WebUrlViewController.swift
//  AlumniCev
//
//  Created by alumnos on 1/2/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import CPAlertViewController

class WebUrlViewController: UIViewController {

    @IBOutlet weak var webTxF: UITextField!
    @IBOutlet weak var webLbl: UILabel!
    @IBOutlet weak var optionalLb: UILabel!
    @IBOutlet weak var addWebLbl: UILabel!
    
    @IBOutlet weak var addWebBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addWebLbl.text = "addWeb".localized()

        addWebBtn.setTitle("add".localized(), for: .normal)
        optionalLb.text = "optional".localized()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func cancelAction(_ sender: Any) {
          self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // MARK:- Add Web
    
    /**
    Function to add a web page to the event
    : conditions: it is important to take into account the following factors:
    * Verify that everything is fine
    * Url with correct format
    
    : param:
    : returns:
    */
    
    @IBAction func addWeb(_ sender: Any) {
        if validateUrl(urlString: webTxF.text){
            eventCreated?.url = webTxF.text
            
            webLbl.text = webTxF.text
            
        }else{
            let alert = CPAlertViewController()
            alert.showError(title: "La URL no tiene un formato válido", buttonTitle: "OK")
        }
    }

}
