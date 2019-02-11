//
//  MessagesViewController.swift
//  AlumniCev
//
//  Created by raul on 13/3/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import Alamofire

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var sendMessaggeTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var id_chat:String?
    var messages = [Dictionary<String,Any>]()
    
    
    
    
    
    
    // MARK:- Create Table
    
    /**
     This function determines the different types of events that our application will have, using a switch.
     : terms:
     
     : param: title, description
     : returns:
     */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //The message is from the user
        let message = messages[indexPath.row] as Dictionary<String,Any>
        if message["id_user"] as? String == getDataInUserDefaults(key: "id"){
            let cell = tableView.dequeueReusableCell(withIdentifier: "myMessage") as! myMessagesTableViewCell
            cell.MessageTextLabel.layer.cornerRadius = cell.frame.height/2
            
            cell.MessageTextLabel.text = (message["description"] as? String)! + "\n\n" + (message["date"] as? String)!
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "otherMessage") as! otherMessageTableViewCell
        cell.messageTextLabel.layer.cornerRadius = cell.frame.height/2
        
        cell.messageTextLabel.text = (message["description"] as? String)! + "\n\n" + (message["date"] as? String)!
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    
    /**
     This function updates the messages
     */
    @IBAction func reloadMessages(_ sender: Any) {
        messagesRequest(id_chat: id_chat!) {messages in
            
            if messages != nil {
                self.messages = messages!
                // recargar la tabla
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        messagesRequest(id_chat: id_chat!) {messages in
            if messages != nil {
                self.messages = messages!
                // recargar la tabla
                self.tableView.reloadData()
            }
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Message Action
    /**
    // Perform the action of sending the message to the recipient
    : conditions:
    
    : param: id
    : returns:
    */
    @IBAction func sendMessageAction(_ sender: Any) {
        if sendMessaggeTextField.text != "" {
            let message = sendMessaggeTextField.text
            sendMessageRequest(id_chat: id_chat!, description: message!, action: { (messageresponse) in
                self.sendMessaggeTextField.text! = ""
                let alert = UIAlertController(title: messageresponse, message: "", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.reloadMessages((Any).self)
                self.present(alert, animated: true)
            })
        }
        
    }
    
    
    
}
