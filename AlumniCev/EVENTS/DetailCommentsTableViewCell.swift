//
//  DetailCommentsTableViewCell.swift
//  AlumniCev
//
//  Created by Daniel Plata on 1/2/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit

class DetailCommentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleComment: UILabel!
    
    @IBOutlet weak var descriptionComment: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
