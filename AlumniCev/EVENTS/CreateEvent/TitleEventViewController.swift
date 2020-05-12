//
//  TitleEventViewController.swift
//  AlumniCev
//
//  Created by alumnos on 24/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit

class TitleEventViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var titleTxtView: UITextView!
    
    @IBOutlet weak var descriptionTxF: UITextView!
    @IBOutlet weak var countTitleLbl: UILabel!
    @IBOutlet weak var countDescriptionLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTxF.delegate = self
        titleTxtView.delegate = self
        
//        addTitleLbl.text = "addTitle".localized()
//        addDescriptionLbl.text = "addDescription".localized()
        
        descriptionTxF.toolbarPlaceholder = "Añade la descripción..."
       // descriptionTxF.placeholderText = "Añade la descripción..."
        titleTxtView.toolbarPlaceholder = "Añade el título..."
        //titleTxtView.placeholderText = "Añade el título..."
        
        setStyle()
    }
    
    func textViewDidChange(_ textView: UITextView){
        countDescriptionLbl.text = String(describing: descriptionTxF.text!.count) + "/2500"
        
        if descriptionTxF.text!.count > 2500{
            countDescriptionLbl.textColor = UIColor.red
        }else{
            countDescriptionLbl.textColor = cevColor
        }
        
        countTitleLbl.text = String(describing: titleTxtView.text!.count) + "/100"
        
        if titleTxtView.text!.count > 100{
            countTitleLbl.textColor = UIColor.red
        }else{
            countTitleLbl.textColor = cevColor
        }
        
    }
    
    func styleTxF(textfield:UITextView){
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = cevColor.cgColor
        border.frame = CGRect(x: 0, y: textfield.frame.size.height - width, width:  textfield.frame.size.width, height: textfield.frame.size.height)
        
        border.borderWidth = width
        textfield.layer.addSublayer(border)
        textfield.layer.masksToBounds = true
        
    }
    
    func setStyle(){
        titleTxtView.layer.borderColor = cevColor.cgColor
        descriptionTxF.layer.borderColor = hexStringToUIColor(hex: "B3B3B3").cgColor
        
        //titleTxtView.layer.borderWidth = 1.0
        descriptionTxF.layer.borderWidth = 1.0
        
        //titleTxtView.layer.cornerRadius = 10
        descriptionTxF.layer.cornerRadius = 10
        
        styleTxF(textfield: titleTxtView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if titleTxtView.text != ""{
            eventCreated?.titleEvent = titleTxtView.text
        }
        
        if descriptionTxF.text != ""{
            eventCreated?.descriptionEvent = descriptionTxF.text
        }

    }
    @IBAction func cancelAction(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
    //We use this function to hide the keyboard when you press out of it
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
  

}
