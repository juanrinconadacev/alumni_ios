//
//  ImageEventViewController.swift
//  AlumniCev
//
//  Created by alumnos on 24/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit
import Photos
import CPAlertViewController

class ImageEventViewController: UIViewController, UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate {
    
    var picker:UIImagePickerController?

    @IBOutlet weak var addImageLbl: UILabel!
    @IBOutlet weak var optionalLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var addImageBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker = UIImagePickerController()
        picker?.delegate = self
        
        addImageLbl.text = "wantImage".localized()
        addImageBtn.setTitle("uploadImage".localized(), for: .normal)
        optionalLabel.text = "optional".localized()
        
    }
    


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    // MARK:- Alert Option Upload Image
    
    /**
    Function that allows us through an alert to choose two options of how to import a photo to our event, it can be through the gallery or through the camera of our mobile
    : conditions: it is important to take into account the following factors:
    * Verify that everything is fine
    
    
    : param:
    : returns:
    */
    
    @IBAction func uploadImageAction(_ sender: UIButton) {
        
        
        let alert = UIAlertController(title: "Usar camara o galeria", message: "¿Quieres subir una foto desde la camara o desde la galeria?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Camara", style: .default, handler: { (nil) in
            self.checkPermissionCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Galeria", style: .default, handler: { (nil) in
            self.checkPermissionGallery()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { (nil) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    
    // MARK:- Camera permission
    /**
    Function that gives us the permissions to be able to use the camera of our mobile
    : conditions: it is important to take into account the following factors:
    * Verify that everything is fine
    
    
    : param:
    : returns:
    */
    
    func checkPermissionCamera() {
        
        // permisos para galeria
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            // pedir permisos
            DispatchQueue.main.async {
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted)  in
                    if granted {
                        self.openCamera()
                    }
                })
            }
        case .denied,.restricted:
            // alert para ir a ajustes
            let alert = UIAlertController(title: "Se necesitan permisos", message: "Se necesitan permisos para acceder a la galeria", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ir a ajustes", style: .default, handler: { (nil) in
                UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            
            present(alert, animated: true)
            
        case .authorized:
            // abrir galeria
            openCamera()
        }
    }
    
    
    
    
    
    
    // MARK:- Galery permission
    /**
     Function that gives us the permissions to be able to use the galery of our mobile
     : conditions: it is important to take into account the following factors:
     * Verify that everything is fine
     
     
     : param:
     : returns:
     */
    
    func checkPermissionGallery() {
        
        // permisos para galeria
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            // pedir permisos
            DispatchQueue.main.async {
                PHPhotoLibrary.requestAuthorization({(newStatus) in
                    print(newStatus)
                    if newStatus == PHAuthorizationStatus.authorized {
                        self.openGallary()
                    }
                    
                })
            }
        case .denied,.restricted:
            // alert para ir a ajustes
            let alert = UIAlertController(title: "Se necesitan permisos", message: "Se necesitan permisos para acceder a la galeria", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Ir a ajustes", style: .destructive, handler: { (nil) in
                UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }))
            present(alert, animated: true)
            
        case .authorized:
            // abrir galeria
            openGallary()
        }
        
        
    }
    
    
    // MARK:- Open Camera
    
    /**
    Function used to open the camera
    : conditions: it is important to take into account the following factors:
    * Verify that everything is fine
    
    
    : param:
    : returns:
    */
    
    func openCamera(){
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerController.SourceType.camera
        present(picker!, animated: true, completion: nil)
    }
    
    
    
    
    
    // MARK:- Open Gallery
    
    /**
     Function used to open the gallery
     : conditions: it is important to take into account the following factors:
     * Verify that everything is fine
     
     
     : param:
     : returns:
     */
    func openGallary()
    {
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(picker!, animated: true, completion: nil)
    }
    
    
    
    
    
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK:- Picker
    
    /**
     This function creates a picker where we can choose a photo from our gallery.
     : terms:
     : param:
     : returns:
     */
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let chosenImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = chosenImage
        
        eventCreated?.imageEvent = chosenImage.jpegData(compressionQuality: 0.1)
        UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil);
        dismiss(animated: true, completion: nil)

    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
