//
//  RequestsTableViewCell.swift
//  AlumniCev
//
//  Created by alumnos on 20/2/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit

class RequestsTableViewCell: UITableViewCell {

    var id_user:Int?
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var declineBtn: UIButton!
    weak var controllerTable : UsersViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func acceptAction(_ sender: Any) {
        requestResponseFriend(id_user: id_user!, type: 2) {_,_ in
            requestRequests(action: {
                self.controllerTable!.rechargeTable()
            }, notRequests: {
                self.controllerTable!.rechargeTable()
                
            })
            
        }
    }
    
    @IBAction func declineAction(_ sender: Any) {
        requestResponseFriend(id_user: id_user!, type: 3) {_,_ in
            requestRequests(action: {
                self.controllerTable!.rechargeTable()
            }, notRequests: {
                self.controllerTable!.rechargeTable()
                
            })
        }
    }
    
}
