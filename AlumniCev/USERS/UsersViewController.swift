//
//  UsersViewController.swift
//  AlumniCev
//
//  Created by Daniel Plata on 22/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var notFriendsLbl: UILabel!
    @IBOutlet weak var notUsersLbl: UILabel!
    
    @IBOutlet var completView: UIView!
    @IBOutlet weak var spinner: NVActivityIndicatorView!
    @IBOutlet weak var segmentedUsers: UISegmentedControl!
    
    @IBOutlet weak var usersTable: UITableView!
    
    var listSelected:String = "users"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Usuarios"
        notFriendsLbl.text = "notFriends".localized()
        
        self.startSpinner()
        
        requestAllUsers {
            self.rechargeTable()
        }
        
        usersTable.estimatedRowHeight = 88
        usersTable.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        segmentedChanged((Any).self)
    }
    
    
    /**
     This function determines which cell has been selected and we instantiate a new view.
     : conditions: unique identifier
     
     : param:
     : returns:
     */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // return de los nombres de los grupos
        if listSelected == "groups"{
            return groups[section]["name"] as? String
        }
        return nil
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // si es grupo devuelvo los grpos del json
        if listSelected == "groups"{
            return groups.count
        }
        return 1
    }
    
    
    
    
    // MARK:- Create Table
    
    /**
     This function determines the different types of events that our application will have, using a switch.
     : conditions:
     
     : param: title, description
     : returns:
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch listSelected {
        case "users", "findUsers", "findFriends":
            if users != nil{
                return users!.count
            }else{
                return 0
            }
        case "groups":
            if groups != nil{
                let users:[Dictionary<String,Any>] = groups[section]["users"] as! [Dictionary<String, Any>]
                return users.count
            }else{
                return 0
            }
        case "friends":
            if users != nil{
                return users!.count
            }else{
                return 0
            }
        case "requests":
            if requests != nil{
                return requests!.count
            }else{
                return 0
            }
        default:
            if users != nil{
                return users!.count
            }else{
                return 0
            }
        }
        
    }
    
    
    
    /**
     This function determines which cell has been selected and we instantiate a new view.
     : conditions: unique identifier
     
     : param:
     : returns:
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch listSelected {
        case "users", "findUsers", "findFriends":
            let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UsersTableViewCell
            
            cell.usernameLbl.isHidden = false
            cell.nameLbl.font = cell.nameLbl.font.withSize(14)
            
            cell.nameLbl.text = users![indexPath.row]["name"] as? String
            
            cell.usernameLbl.text = users![indexPath.row]["username"] as? String
            
            if users![indexPath.row]["photo"] as? String != nil{
                //Añadir imagen
                let remoteImageURL = URL(string: (users![indexPath.row]["photo"] as? String)!)!
                
                Alamofire.request(remoteImageURL).responseData { (response) in
                    if response.error == nil {
                        print(response.result)
                        
                        if let data = response.data {
                            cell.photoImag.image = UIImage(data: data)
                        }
                    }
                }
            }else{
                cell.photoImag.image = #imageLiteral(resourceName: "userdefaulticon")
            }

            cell.photoImag.contentMode = .scaleAspectFill
            cell.photoImag.layer.cornerRadius = cell.photoImag.bounds.height/2
            cell.photoImag.layer.masksToBounds = true
            
            return cell
        case "groups":

            let users = groups[indexPath.section]["users"] as! [Dictionary<String,Any>]


            let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UsersTableViewCell

            cell.usernameLbl.isHidden = false
            cell.nameLbl.font = cell.nameLbl.font.withSize(14)

            cell.nameLbl.text = users[indexPath.row]["name"] as? String

            cell.usernameLbl.text = users[indexPath.row]["username"] as? String

            if users[indexPath.row]["photo"] as? String != nil{
                //Añadir imagen
                let remoteImageURL = URL(string: (users[indexPath.row]["photo"] as? String)!)!

                Alamofire.request(remoteImageURL).responseData { (response) in
                    if response.error == nil {
                        print(response.result)

                        if let data = response.data {
                            cell.photoImag.image = UIImage(data: data)
                        }
                    }
                }
            }else{
                cell.photoImag.image = #imageLiteral(resourceName: "userdefaulticon")
            }

            cell.photoImag.contentMode = .scaleAspectFill
            cell.photoImag.layer.cornerRadius = cell.photoImag.bounds.height/2
            cell.photoImag.layer.masksToBounds = true

            return cell

        case "friends":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UsersTableViewCell
            
            cell.nameLbl.text = users![indexPath.row]["name"] as? String
            cell.usernameLbl.isHidden = false
            cell.usernameLbl.text = users![indexPath.row]["username"] as? String
            
            if users![indexPath.row]["photo"] as? String != nil{
                //Añadir imagen
                let remoteImageURL = URL(string: (users![indexPath.row]["photo"] as? String)!)!
                
                Alamofire.request(remoteImageURL).responseData { (response) in
                    if response.error == nil {
                        print(response.result)
                        
                        if let data = response.data {
                            cell.photoImag.image = UIImage(data: data)
                        }
                    }
                }
            }else{
                cell.photoImag.image = #imageLiteral(resourceName: "userdefaulticon")
            }
            
            cell.photoImag.contentMode = .scaleAspectFill
            cell.photoImag.layer.cornerRadius = cell.photoImag.bounds.height/2
            cell.photoImag.layer.masksToBounds = true
            
            return cell
        case "requests":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath) as! RequestsTableViewCell
            
            let id = getDataInUserDefaults(key: "id")!
            
            let sendUser = requests![indexPath.row]["username"] as! String
            
            if requests![indexPath.row]["state"] as! String == "1"{
                
                if requests![indexPath.row]["id_user_receive"] as? String == id{
                    cell.titleLbl.text = "\(sendUser) te ha enviado una petición de amistad"
                    
                    cell.controllerTable = self
                    
                }else{
                    cell.titleLbl.text = "Has enviado una petición a \(sendUser)"
                    cell.acceptBtn.isHidden = true
                    cell.declineBtn.isHidden = true
                }
                
            }else{
                
                if requests![indexPath.row]["id_user_receive"] as? String == id{
                    cell.titleLbl.text = "Has aceptado la petición de \(sendUser). Ya sois amigos!"
                    cell.acceptBtn.isHidden = true
                    cell.declineBtn.isHidden = true
                }else{
                    cell.titleLbl.text = "\(sendUser) ha aceptado tu petición. Ya sois amigos!"
                    cell.acceptBtn.isHidden = true
                    cell.declineBtn.isHidden = true
                }
                
            }
            
            cell.id_user = Int(requests![indexPath.row]["id"] as! String)
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UsersTableViewCell
            cell.nameLbl.text = users![indexPath.row]["username"] as? String
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch listSelected {
        case "requests":
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
            vc.user = (requests![indexPath.row] as Dictionary<String,Any>?)!
            
            self.navigationController?.pushViewController(vc, animated: true)
            //self.present(vc, animated: true, completion: nil)
            
            break
        case "groups":
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
            
            //print(groups)
            let myGroup = groups[indexPath.section]
            //print(myGroup)
            let myUsers = myGroup["users"] as! [Dictionary<String,Any>]
            //print(myUsers)
            vc.user = myUsers[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
            vc.user = (users![indexPath.row] as Dictionary<String,Any>?)!
            self.navigationController?.pushViewController(vc, animated: true)
            //self.present(vc, animated: true, completion: nil)
        }

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        <#code#>
//    }
    
    
    
    
    // MARK: -Navigation Controller
    /**
    We created the navigationController
    : conditions: it is important to take into account the following factors:
    * Verify that everything is fine
    
    
    : param:
    : returns:
    */
    
    @IBAction func segmentedChanged(_ sender: Any) {
        startSpinner()
        self.notUsersLbl.isHidden = true
        switch segmentedUsers.selectedSegmentIndex{
            
        case 0:
            self.navigationController?.navigationBar.topItem?.title = "Usuarios"
            listSelected = "users"
            requestAllUsers {
                self.rechargeTable()
                self.stopSpinner()
            }
            
        case 1:
            self.navigationController?.navigationBar.topItem?.title = "Grupos"
            listSelected = "groups"
            requestGroupsbyUser {
                self.rechargeTable()
                self.stopSpinner()
            }
            
        case 2:
            self.navigationController?.navigationBar.topItem?.title = "Amigos"
            listSelected = "friends"
            requestFriends {
                self.rechargeTable()
                self.stopSpinner()
                
                if users?.count == 0{
                    self.usersTable.isHidden = true
                    self.notFriendsLbl.isHidden = false
                    self.notFriendsLbl.text = "Not friends"
                }
            }
            
        case 3:
            self.navigationController?.navigationBar.topItem?.title = "Solicitudes"
            listSelected = "requests"
            
            requestRequests(action: {
                self.rechargeTable()
                self.stopSpinner()
            }, notRequests: {
                self.usersTable.isHidden = true
                self.notFriendsLbl.isHidden = false
                self.notFriendsLbl.text = "No hay peticiones"
            })
            
        default:
            self.navigationController?.navigationBar.topItem?.title = "Usuarios"
            listSelected = "users"
            requestAllUsers {
                self.rechargeTable()
                self.stopSpinner()
            }
        }
        stopSpinner()
    }

    
    
    
    
    
    // MARK:- Search engine
    /**
    Introducing a text we can find the different events, groups, ... that we have in our application
    : conditions: it is important to take into account the following factors:
    * Verify that everything is fine
    
    
    : param:
    : returns:
    */
    
    @IBAction func searchChanged(_ sender: UITextField) {
        
        if sender.text != ""{
            
            if segmentedUsers.selectedSegmentIndex == 0{
                listSelected = "findUsers"
                
                requestFindUser(search: sender.text!, action: {
                    self.notUsersLbl.isHidden = true
                    self.rechargeTable()
                }, notusers: {
                    self.notUsersLbl.isHidden = false
                    self.usersTable.isHidden = true
                })
            }else if segmentedUsers.selectedSegmentIndex == 2{
                listSelected = "findFriends"
                
                requestFindFriends(search: sender.text!, action: {
                    self.notUsersLbl.isHidden = true
                    self.rechargeTable()
                }, notusers: {
                    self.notUsersLbl.isHidden = false
                    self.usersTable.isHidden = true
                })
            }

        }else{
            notUsersLbl.isHidden = true
            switch segmentedUsers.selectedSegmentIndex{
                
            case 0:
                listSelected = "users"
                requestAllUsers {
                    self.rechargeTable()
                    self.stopSpinner()
                }
                
            case 1:
                listSelected = "groups"
                requestGroups {
                    self.rechargeTable()
                    self.stopSpinner()
                }
                
            case 2:
                listSelected = "friends"
                requestFriends {
                    self.rechargeTable()
                    self.stopSpinner()
                    
                    if users?.count == 0{
                        self.usersTable.isHidden = true
                        self.notFriendsLbl.isHidden = false
                        self.notFriendsLbl.text = "Not friends"
                    }
                }
                
            case 3:
                listSelected = "requests"
                requestRequests(action: {
                    self.rechargeTable()
                    self.stopSpinner()
                }, notRequests: {
                    self.usersTable.isHidden = true
                    self.notFriendsLbl.isHidden = false
                    self.notFriendsLbl.text = "No hay peticiones"
                })
                
            default:
                listSelected = "users"
                requestAllUsers {
                    self.rechargeTable()
                    self.stopSpinner()
                }
            }
            rechargeTable()
        }
        
    }
    
    
    
    
    /**
     This function updates the table
     */
    
    @objc func rechargeTable(){
        usersTable.isHidden = false
        notFriendsLbl.isHidden = true
        usersTable.reloadData()
        self.stopSpinner()
    }
    
    func startSpinner(){
        completView.isUserInteractionEnabled = false
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    func stopSpinner(){
        completView.isUserInteractionEnabled = true
        spinner.isHidden = true
        spinner.stopAnimating()
    }
    

}
