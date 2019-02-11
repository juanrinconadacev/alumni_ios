//
//  CellChatsTableViewCell.swift
//  AlumniCev
//
//  Created by raul on 15/3/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit

class CellChatsTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
