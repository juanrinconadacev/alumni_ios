

import UIKit
import SimpleAnimation
import Alamofire

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableEvents: UITableView!
    
    @IBOutlet weak var segmentedTypes: UISegmentedControl!
    
    @IBOutlet weak var searchTxF: UITextField!
    
    @IBOutlet weak var withoutResults: UILabel!
    

    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var filterBtn: UIButton!
    var selectedtypebtn:UIButton?
    
    @IBOutlet weak var allTypesBtn: UIButton!
    
    var idType:Int = 0
    
    @IBOutlet weak var menuView: UIView!
    
    //Create the table
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return events.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    
    
    
    // MARK:- Create Table
    
    /**
    This function determines the different types of events that our application will have, using a switch.
    : terms:
    
    : param: title, description
    : returns:
    */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! EventTableViewCell
        
        cell.titleLbl.text = events[indexPath.row]["title"] as? String
        cell.descriptionLbl.text = events[indexPath.row]["description"] as? String
        
        var typeEvent = ""
        var color:UIColor?
        
        switch(events[indexPath.row]["id_type"] as? String){
            
        case "1"?:
            typeEvent = "Evento"
            color = hexStringToUIColor(hex: "5E797A")
            cell.imageTypeEvent.image = #imageLiteral(resourceName: "eventsiconlist")
            
        case "2"?:
            typeEvent = "Oferta de trabajo"
            color = hexStringToUIColor(hex: "40C0C6")
            cell.imageTypeEvent.image = #imageLiteral(resourceName: "joboffericonlist")
        case "3"?:
            typeEvent = "Notificación"
            color = hexStringToUIColor(hex: "4F5E74")
            cell.imageTypeEvent.image = #imageLiteral(resourceName: "notificationsiconlist")
        case "4"?:
            typeEvent = "Noticia"
            color = hexStringToUIColor(hex: "62BD91")
            cell.imageTypeEvent.image = #imageLiteral(resourceName: "newsiconlist")
        default:
            typeEvent = ""
            color = UIColor.red.withAlphaComponent(0.4)
            cell.imageTypeEvent.image = #imageLiteral(resourceName: "eventsiconlist")
        }
        
        if events[indexPath.row]["image"] as? String != nil{
            //Añadir imagen
            let remoteImageURL = URL(string: (events[indexPath.row]["image"] as? String)!)!
            
            AF.request(remoteImageURL).responseData { (response) in
                if response.error == nil {
                    print(response.result)
                    
                    if let data = response.data {
                        cell.imageEventView.image = UIImage(data: data)
                    }
                }
            }
        }else{
            switch(events[indexPath.row]["id_type"] as? String){
                
            case "1"?:
                cell.imageEventView.image = UIImage(named: "eventimage")
            case "2"?:
                cell.imageEventView.image = UIImage(named: "jobofferimage")
            case "3"?:
                cell.imageEventView.image = UIImage(named: "notificationimage")
            case "4"?:
                cell.imageEventView.image = UIImage(named: "newsimage")
            default:
                cell.imageEventView.image = UIImage(named: "eventimage")
            }
        }
        
        cell.imageEventView.contentMode = .scaleAspectFill
        cell.imageEventView.layer.masksToBounds = true
        
        cell.typeLbl.text = typeEvent
        //cell.typeLbl.backgroundColor = color
        cell.backgroundCell.backgroundColor = color
        cell.typeLbl.layer.cornerRadius = 15.0
        cell.typeLbl.layer.masksToBounds = true
        return cell
    }
    
    
   
    
    /**
    This function determines which cell has been selected and we instantiate a new view.
    : conditions: unique identifier
    
    : param:
    : returns:
    */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("He pulsado la celda \(indexPath.row)")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailEventViewController") as! DetailEventViewController
        globalidReceived = indexPath.row
        
        //self.present(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /**
     This function we instantiate a new view.
     
     : conditions: it is important to take into account the following factors:
     * Unique identifier
     
     : param:
     : returns:
     */
    
    @IBAction func goToCreate(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateEventPageViewController") as! CreateEventPageViewController
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    /**
    This function updates the table
    */
    
    func reloadTable(){
        tableEvents.reloadData()
        tableEvents.isHidden = false
        withoutResults.isHidden = true
    }
    
    
    // MARK:- Event search engine
    
    /**
    This function performs a search of all the events in the application and updates the list again
    : conditions: matching text
    
    : param: text
    : returns:
    */
    
    @IBAction func changeTextAction(_ sender: Any) {
        
        if (sender as! UITextField).text! == ""{
            requestEvents(type: idType, action: {
                self.reloadTable()
            }, notResults: {
                self.notResults()
            })
        }else{
            requestFindEvents(search: (sender as! UITextField).text!,type: idType, controller: self)
        }
        
    }
    
    func notResults(){
        withoutResults.isHidden = false
        tableEvents.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedtypebtn = allTypesBtn
        
        allTypesBtn.backgroundColor = cevColor
        allTypesBtn.setTitleColor(UIColor.white, for: .normal)
        
        
        menuView.isHidden = true
        //ocultView.isHidden = true
        
        //menuView.layer.cornerRadius = 15.0
        //menuView.layer.masksToBounds = true
        cancelBtn.layer.cornerRadius = 15.0
        cancelBtn.layer.masksToBounds = true
//        filterBtn.layer.cornerRadius = 15.0
//        filterBtn.layer.masksToBounds = true
        
        withoutResults.isHidden = true
        
        tableEvents.rowHeight = UITableView.automaticDimension
        tableEvents.estimatedRowHeight = 209
        
        requestEvents(type: idType, action: {
            self.reloadTable()
        }, notResults: {
            self.notResults()
        })
        
        tableEvents.separatorStyle = .none

        //Profile picture on the corner
        if(getDataInUserDefaults(key: "photo") != nil){
            let photo:Data = Data(base64Encoded: getDataInUserDefaults(key: "photo")!)!
            userImage.image = UIImage(data: photo)
            
        }else{
            userImage.image = #imageLiteral(resourceName: "userdefaulticon")
        }
        
        userImage.layer.cornerRadius = userImage.frame.size.height/2
        userImage.layer.masksToBounds = true
        userImage.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        userImage.layer.borderWidth = 1
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func goToProfile(_ sender: Any) {
        self.tabBarController?.selectedIndex = 3
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
        
        print("CARGANDO PANTALLA DE EVENTSVIEWCONTROLLER ----- view WillAppear")
        //Profile picture on the corner
        
        
        if(getDataInUserDefaults(key: "photo") != nil){
            let photo:Data = Data(base64Encoded: getDataInUserDefaults(key: "photo")!)!
            userImage.image = UIImage(data: photo)
            
        }else{
            userImage.image = #imageLiteral(resourceName: "userdefaulticon")
        }
        
        
        print("Ejecutando la PETICON DE LOS EVENTOS ----- view WillAppear")
        requestEvents(type: idType, action: {
            self.reloadTable()
        }, notResults: {
            self.notResults()
        })
        switch(idType){
        case 0:
            self.navigationController?.navigationBar.topItem?.title = "Tablon"
        case 1:
            self.navigationController?.navigationBar.topItem?.title = "Eventos"
        case 2:
            self.navigationController?.navigationBar.topItem?.title = "Ofertas de trabajo"
        case 3:
            self.navigationController?.navigationBar.topItem?.title = "Notificaciones"
        case 4:
            self.navigationController?.navigationBar.topItem?.title = "Noticias"
        default:
            break;
        }
    }
    @IBAction func filterAction(_ sender: Any) {
        menuView.isHidden = false
        menuView.bounceIn(from: .top)
        
        //ocultView.isHidden = false
        
    }
    
    @IBAction func changeType(_ sender: UIButton) {
        
        if selectedtypebtn != nil{
            selectedtypebtn!.tintColor = cevColor
            selectedtypebtn!.backgroundColor = UIColor.white
            selectedtypebtn!.setTitleColor(cevColor, for: .normal)
        }
        
        selectedtypebtn = sender
        
        idType = sender.tag
        sender.backgroundColor = cevColor
        sender.setTitleColor(UIColor.white, for: .normal)
        
        if searchTxF.text == ""{
            requestEvents(type: idType, action: {
                self.reloadTable()
            }, notResults: {
                self.notResults()
            })
        }else{
            requestFindEvents(search: searchTxF.text!, type: idType, controller: self)
        }


        
        switch(idType){
        case 0:

            self.navigationController?.navigationBar.topItem?.title = "Tablon"
        case 1:

            self.navigationController?.navigationBar.topItem?.title = "Eventos"
        case 2:

            self.navigationController?.navigationBar.topItem?.title = "Ofertas de trabajo"
        case 3:

            self.navigationController?.navigationBar.topItem?.title = "Notificaciones"
        case 4:

            self.navigationController?.navigationBar.topItem?.title = "Noticias"
        default:
            break
        }
        
        closeMenu(sender)
        
    }
    
    @IBAction func closeMenu(_ sender: Any) {
        menuView.bounceOut(to: .top)
        //menuView.isHidden = true
        //ocultView.isHidden = true
    }

    //We use this function to hide the keyboard when you press out of it
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
