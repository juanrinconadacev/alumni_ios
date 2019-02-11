//
//  myMessagesTableViewCell.swift
//  AlumniCev
//
//  Created by raul on 13/3/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit

class myMessagesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var MessageTextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
