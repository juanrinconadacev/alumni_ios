//
//  DetailEventViewController.swift
//  AlumniCev
//
//  Created by alumnos on 23/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import Alamofire
import CPAlertViewController

class DetailEventViewController: UIViewController{
    
    var idReceived: Int = 0

    @IBOutlet weak var commentView: UIView!
    
    @IBOutlet weak var secondTitleLbl: UILabel!
    
    @IBOutlet weak var descriptionText: UITextView!
    
    @IBOutlet weak var imageViewEvent: UIImageView!
    
    @IBOutlet weak var webBtn: UIButton!
    @IBOutlet weak var localizationBtn: UIButton!
    @IBOutlet weak var photoUser: UIImageView!
    
    @IBOutlet weak var commentTxF: UITextField!

    @IBOutlet weak var usernameBtn: UIButton!
    
    @IBOutlet weak var descriptionTxF: UITextView!
    @IBOutlet weak var photoUserComment: UIImageView!
    
    @IBOutlet weak var seeCommentsBtn: UIButton!
    @IBOutlet weak var deleteEventBtn: UIButton!
    
    @IBOutlet weak var dateComment: UILabel!
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var imageFromIMGViewer: UIImageView!
    @IBOutlet weak var imageViewer: UIView!
    
    var lat:Float?
    var lon:Float?
    
    
    //remove image viewer
    
    @IBAction func dismissImageViewer(_ sender: Any) {
        imageViewer.isHidden = true
        
    }
    
    //show image viewer
    @IBAction func showImageViewer(_ sender: Any) {
        imageViewer.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        idReceived = globalidReceived!
        let id = Int(getDataInUserDefaults(key: "id")!)
        let id_rol = Int(getDataInUserDefaults(key: "id_rol")!)
        
        self.dateComment.isHidden = true
        
        //styleTxF(textfield: commentTxF)
        
        descriptionTxF.layer.cornerRadius = 15.0
        descriptionText.layer.cornerRadius = 15.0
        
        seeCommentsBtn.layer.cornerRadius = seeCommentsBtn.layer.frame.height / 2
        
        if(getDataInUserDefaults(key: "photo") != nil){
            let photo:Data = Data(base64Encoded: getDataInUserDefaults(key: "photo")!)!
            photoUser.image = UIImage(data: photo)
            
        }
        
        photoUser.layer.cornerRadius = photoUser.frame.size.height/2
        photoUser.layer.masksToBounds = true
        
        print("sacando el id disponible")
        print(events[idReceived]["id"]!)
        
        let idCasted = (events[idReceived]["id"] as! NSNumber).intValue
        requestEvent(id: idCasted) {
            print("elevneto contiene tantos comentarios:::::::")
            if comments?.count == nil{ print("el evento no tiene comentarios")}
            //print(comments!.count)
            if(comments!.count > 0){
                self.setComment()
            }
        
        let idEvent = (events[self.idReceived]["id_user"] as! NSNumber).intValue
            if idEvent == id || id_rol == 1{
                self.deleteEventBtn.isHidden = false
            }
            
        }
        
        //Adjust TextView to content
        
        descriptionText.sizeToFit()
        descriptionText.isScrollEnabled = false
        
        imageViewEvent.clipsToBounds = true
        imageViewEvent.contentMode = .scaleAspectFill
        
        
        
        //Only the location information is displayed if the event has it
        
        if((events[idReceived]["lat"] as? String) != nil && (events[idReceived]["lon"] as? String) != nil){
        
            lat = Float(events[idReceived]["lat"] as! String)
            lon = Float(events[idReceived]["lon"] as! String)
            
            addressFromPosition(lat: lat!, lon: lon!, controller: self)
            
            //localizationBtn.isHidden = false
        }else{
            localizationBtn.isEnabled = false
            
        }
        
        if events[idReceived]["url"] as? String == nil{
            webBtn.isEnabled = false
            
        }else{
            webBtn.isEnabled = true
        }
        
        if events[idReceived]["image"] as? String == nil{
            switch events[idReceived]["id_type"] as! String {
            case "1":
                imageViewEvent.image = UIImage(named: "eventimage")
            case "2":
                imageViewEvent.image = UIImage(named: "jobofferimage")
            case "3":
                imageViewEvent.image = UIImage(named: "notificationimage")
            case "4":
                imageViewEvent.image = UIImage(named: "newsimage")
            default:
                imageViewEvent.image = UIImage(named: "eventimage")
            }
        }else{
            requestImage(url: (events[idReceived]["image"] as? String)!)
        }
        
        setInfoEvent()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // quitar tab bar
        self.tabBarController?.tabBar.isHidden = true
        let idCasted = (events[idReceived]["id"] as! NSNumber).intValue
        requestEvent(id: idCasted) {
            print("va a petar aqui")
            if(comments!.count > 0){
                self.setComment()
            }else{
                self.commentView.isHidden = true
            }
            
        }
    }
    
    
    // MARK:- Link
    /**
    We introduce a link that will send us to an external website
    : conditions: valid link
    
    : param: url
    : returns:
    */
    
    @IBAction func opendURL(_ sender: Any) {
        
        if let url = URL(string: (events[idReceived]["url"] as? String)!) {
            UIApplication.shared.open(url, options: [:])
        }
        
    }
    
    
    
    /**
    Collect the events
    : terms:
    
    : param:
    : returns:
    */
    
    
    func setEvent(address:Address){
        setInfoEvent()
    }
    
    
    
    
    /**
    Collect the  info events
    : terms:
    
    : param:
    : returns:
    */
    
    
    func setInfoEvent(){
        secondTitleLbl.text = events[idReceived]["title"] as? String
        descriptionText.text = events[idReceived]["description"] as? String
        
        if !(events[idReceived]["date"]! is NSNull){
            dateLbl.text = "Creado: \(String(describing: events[idReceived]["date"]! as! String))"
        }
    
        
    }
    
    
    

    /**
    Let's instant the screen of location of our application
    : conditions:
    
    : param: url
    : returns:
    */
    
    @IBAction func goToLocalization(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventLocalizationViewController") as! EventLocalizationViewController
        
        vc.lat = self.lat!
        vc.lon = self.lon!
        vc.titleEvent = (events[idReceived]["title"] as? String)!
        self.navigationController?.pushViewController(vc, animated: true)
        //self.present(vc, animated: true, completion: nil)
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK:- Request Image
    /**
    We make a Request where we download our image
    : conditions:
    
    : param: url
    : returns:
    */
    
    func requestImage(url:String){
        let remoteImageURL = URL(string: url)!
        
        // Use Alamofire to download the image
        Alamofire.request(remoteImageURL).responseData { (response) in
            if response.error == nil {
                print(response.result)
                
                if let data = response.data {
                    self.imageViewEvent.image = UIImage(data: data)
                    self.imageFromIMGViewer.image = UIImage(data: data)
                    self.imageFromIMGViewer.contentMode = .scaleAspectFit
                    self.imageFromIMGViewer.layer.masksToBounds = true
                    
                }
            }
        }
    }
    
    
    
    // MARK:- Image Comment
    /**
    We make a Request where we download our image
    : conditions:
    
    : param: url, image
    : returns:
    */
    func requestImageComment(url:String, image:UIImageView){
        let remoteImageURL = URL(string: url)!
        
        // Use Alamofire to download the image
        Alamofire.request(remoteImageURL).responseData { (response) in
            if response.error == nil {
                print(response.result)
                
                if let data = response.data {
                    image.image = UIImage(data: data)
                }
            }
        }
    }
    
    
    

    // MARK: Link
    /**
    We collect the comments and show them in the application
    : conditions:
    
    : param: username, description, date, photo
    : returns:
    */
    func setComment(){
        
        commentView.isHidden = false
        
        print("va a petar aqui")
        print(comments?.count)
        print(comments![0])
        var lastComment = comments![0]
        
        self.usernameBtn.setTitle(lastComment["username"] as? String, for: .normal)
        self.descriptionTxF.text = lastComment["description"] as! String
        
        if lastComment["date"] as? String != nil{
            self.dateComment.isHidden = false
            self.dateComment.text = lastComment["date"] as? String
        }
        
        if lastComment["photo"] as? String != nil{
            requestImageComment(url: (lastComment["photo"] as? String)!, image: photoUserComment)
        }else{
            photoUserComment.image = UIImage(named: "userdefaulticon")
        }
        
        photoUserComment.layer.cornerRadius = photoUserComment.frame.size.height/2
        photoUserComment.layer.masksToBounds = true

        if comments!.count > 1{
            self.seeCommentsBtn.setTitle("Ver \(comments!.count) comentarios", for: .normal)
        }else{
            self.seeCommentsBtn.setTitle("Ver 1 comentario", for: .normal)
        }

    }
    
    
    
    /**
    We made the action to send comments
    : conditions:
    
    : parameter: id
    : returns:
    */
    
    @IBAction func sendCommentAction(_ sender: Any) {
        
        let idCasted = (events[idReceived]["id"] as! NSNumber).intValue
        print("casteando id .....")
        
        requestCreateComment(title: "ComentarioTest", description: commentTxF.text!, id_event: idCasted){
            print("id enviado...")
            let alert = CPAlertViewController()
            
            alert.showSuccess(title: "alertExit".localized(), message: "createdComment".localized(), buttonTitle: "OK", action: { (nil) in
                let idCastedd = (events[self.idReceived]["id"] as! NSNumber).intValue
                
                requestEvent(id: idCastedd) {
                    self.setComment()
                    
                    self.commentTxF.text = ""
                }
            })
            
            
        }
    
    }
    
    
    /**
     Let's instant the screen of user details of our application
     : conditions:
     
     : param: Identifier
     : returns:
     */
    @IBAction func goToUser(_ sender: Any) {
        var lastComment = comments![0]
        
        requestUserById(id: Int(lastComment["id_user"] as! String)!) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
            vc.user = user
            self.navigationController?.pushViewController(vc, animated: true)
            //self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    
    
    /**
     Let's instant the screen of comments of our application
     : conditions:
     
     : param: Identifier
     : returns:
     */
    
    @IBAction func goToCommentsAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
        
        let idCasted = (events[self.idReceived]["id"] as! NSNumber).intValue
        let idCastedUser = (events[self.idReceived]["id_user"] as! NSNumber).intValue
        
        vc.id_event = idCasted
        vc.id_user_event = idCastedUser
        self.navigationController?.pushViewController(vc, animated: true)
        //self.present(vc, animated: false, completion: nil)
    }
    
    func styleTxF(textfield:UITextField){
        
        let border = CALayer()
        let width = CGFloat(2.0)
        
        border.borderColor = cevColor.cgColor
        border.frame = CGRect(x: 0, y: 0, width:  textfield.frame.size.width, height: 1)
        
        border.borderWidth = width
        textfield.layer.addSublayer(border)
        textfield.layer.masksToBounds = true
        
        textfield.setValue(UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5), forKeyPath: "_placeholderLabel.textColor")
        
    }
    
    
    
    // MARK:- Delete events
    /**
    The following function deletes the events
    : conditions:
    
    : parameter: id
    : returns:
    */
    @IBAction func deleteEventAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "deleteEvent".localized(), message: "sureDeleteEvent".localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "delete".localized(), style: .destructive, handler: { (nil) in
            requestDeleteEvent(id: Int(events[self.idReceived]["id"] as! String)!){
                //self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }

            }))
        self.present(alert, animated: true)
        

    }

}
