//
//  MainViewController.swift
//  AlumniCev
//
//  Created by alumnos on 17/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var dataLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = getDataInUserDefaults(key: "name")
        let email = getDataInUserDefaults(key: "email")
        let password = getDataInUserDefaults(key: "password")
        dataLabel.text = "Bienvenido: " + name! + "\n" + "email: " + email! + "\n" + "password: " + password!
        // Do any additional setup after loading the view.
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
