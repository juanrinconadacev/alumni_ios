//
//  GroupEventViewController.swift
//  AlumniCev
//
//  Created by alumnos on 25/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import M13Checkbox

class GroupEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var groupsLbl: UILabel!
    
    @IBOutlet weak var groupsTable: UITableView!
    
    
    
    /**
     This function determines which cell has been selected and we instantiate a new view.
     : conditions: unique identifier
     
     : param: name, id
     : returns:
     */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventsCell", for: indexPath) as! GroupsTableViewCell
        
        cell.groupLbl.text = groups[indexPath.row]["name"] as? String
        print("HAYYYYYYYYY AGLOOOOO AQUIIIIIIIIIIIIII?????")
       // print("\(groups[indexPath.row]["id"])")
        let idCasted = (groups[indexPath.row]["id"] as! NSNumber).intValue
        cell.idGroup = idCasted
        
      //  saveDataInUserDefaults(value: "\(String(describing: arrayUser["phone"]))" , key: "phoneprivacity")
        
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestGroups{
            self.rechargeTable()
        }
        
        groupsLbl.text = "whatGroups".localized()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    /**
     This function updates the table
     */
    
    func rechargeTable(){
        groupsTable.reloadData()
    }
    
    
    
    /**
     This function cancel the action
     */
    @IBAction func cancelAction(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
