//
//  CommentsTableViewCell.swift
//  AlumniCev
//
//  Created by Daniel Plata on 8/2/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var usernameBtn: UIButton!
    
    @IBOutlet weak var descriptionTxV: UITextView!
    
    var controller:CommentsViewController?
    var idComment:Int?
    
    var id_user:Int?
    
    @IBOutlet weak var deleteBtn: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        descriptionTxV.layer.cornerRadius = 15.0
    }

    
    
    
    // MARK:- Delete comments
    /**
    Delete existing comments
    : conditions:
    : parameter: id
    : returns:
    */
    
    @IBAction func deleteCommentAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Borrar comentario", message: "¿Seguro que quieres borrar el comentario?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Borrar", style: .destructive, handler: { (nil) in
            
            requestDeleteComment(id_comment: self.idComment!, action: {
                
                self.controller?.reloadTable()
                //self.controller?.dismiss(animated: true, completion: nil)
            })
        }))
        
        controller?.present(alert, animated: true)


    }
    
    
    
    
        
    /**
       This function allows the screen change, indicating the name of the new one.
                         
       : conditions: It is important to take into account the following factors:
       * Unique identifier
                         
       : param: sender Button that performs the action
       : returns:
         */
    @IBAction func goToUserAction(_ sender: Any) {
        
        requestUserById(id: id_user!) {
            let vc = self.controller?.storyboard?.instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
            vc.user = user
            self.controller?.navigationController?.pushViewController(vc, animated: true)
            //self.controller?.present(vc, animated: true, completion: nil)
        }

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
