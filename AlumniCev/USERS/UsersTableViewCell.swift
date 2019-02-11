//
//  UsersTableViewCell.swift
//  AlumniCev
//
//  Created by Daniel Plata on 7/2/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var photoImag: UIImageView!
    @IBOutlet weak var infoImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
