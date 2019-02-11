//
//  CreateChatViewController.swift
//  AlumniCev
//
//  Created by alumnos on 14/3/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import Alamofire

class CreateChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var userstochat:[Dictionary<String,Any>] = []
    
    
    
    
    // MARK:- Create Table
    
    /**
     This function determines the different types of events that our application will have, using a switch.
     : terms:
     
     : param: title, description
     : returns:
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (userstochat.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userToChat") as! CellUserToChatViewController
        
        cell.userName.text = userstochat[indexPath.row]["username"] as? String
        cell.id_user = userstochat[indexPath.row]["id"] as? Int
        cell.userImage.image = UIImage(named: "userdefaulticon")
        if userstochat[indexPath.row]["photo"] as? String != nil{
            //Añadir imagen
            let remoteImageURL = URL(string: (userstochat[indexPath.row]["photo"] as? String)!)!
            
            Alamofire.request(remoteImageURL).responseData { (response) in
                if response.error == nil {
                    print(response.result)
                    
                    if let data = response.data {
                        cell.userImage.image = UIImage(data: data)
                    }
                }
            }
        }


        cell.userImage.layer.cornerRadius = cell.userImage.frame.size.height/2
        cell.userImage.layer.masksToBounds = true
        cell.userImage.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.userImage.layer.borderWidth = 1
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Iniciar nuevo chat", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (nil) in
            //request create chat with id user
            let id_user = self.userstochat[indexPath.row]["id"] as? String
            createChatRequesst(id_user: id_user!, action: { (chat) in
                // go to the messages tab with the chat id in the answer
                if chat != nil{
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessagesViewController") as! MessagesViewController
                    vc.id_chat = chat["id"] as? String
                    print(vc.id_chat)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
        }))
        alert.addAction(UIAlertAction(title: "cancelar", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUsersToChat { (users) in
            if users != nil {
                self.userstochat = users!
                self.tableView.reloadData()
            }else{
                let alertController = UIAlertController(title: "No hay amigos con los que iniciar un chat nuevo", message: "", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title:"Volver", style: .default, handler: { (nil) in
                    self.navigationController?.popViewController(animated: true)
                })
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)                    }
        }
    }
}




