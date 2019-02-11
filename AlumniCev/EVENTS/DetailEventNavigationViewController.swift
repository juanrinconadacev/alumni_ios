//
//  DetailEventNavigationViewController.swift
//  AlumniCev
//
//  Created by alumnos on 7/3/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit

class DetailEventNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.isTranslucent = false
        //self.navigationBar.backgroundColor = .red
        self.navigationBar.barTintColor = UIColor(named: "Turques")
        self.navigationBar.tintColor = .white
        self.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.white
        ]
        
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
