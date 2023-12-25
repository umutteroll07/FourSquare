//
//  PlacesVC.swift
//  FourSquare
//
//  Created by Umut Erol on 17.12.2023.
//

import UIKit
import Parse

class PlacesVC: UIViewController  ,UITableViewDelegate , UITableViewDataSource{
  
    
    var placeNameArray = [String]()
    var placeIdArray =  [String]()
    var selectedId = ""
    var userName = ""
    var userNameCurrent = ""
    
    @IBOutlet weak var tableView_places: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("random")
        
        let user = PFUser.current()
        self.userNameCurrent = (user?.username)!
        
        
        
        tableView_places.delegate = self
        tableView_places.dataSource = self

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target:self , action: #selector(addPlace))
 
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logOut))
        
        getDataFromParse()

    }
    
    func getDataFromParse() {
        let query = PFQuery(className: "PlaceInfo")
        query.whereKey("userName", contains: userNameCurrent)
        query.selectKeys(["name"])
        query.findObjectsInBackground { object, error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Parse query error", preferredStyle: UIAlertController.Style.alert)
                let alertButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                alert.addAction(alertButton)
                self.present(alert, animated: true)
            }
            else {
                
                self.placeIdArray.removeAll(keepingCapacity: false)
                self.placeNameArray.removeAll(keepingCapacity: false)
                for objectQuery in object! {
                    if let placeId = objectQuery.objectId {
                        if let placeName = objectQuery["name"] as? String {
                            self.placeIdArray.append(placeId)
                            self.placeNameArray.append(placeName)
                            self.userName = self.userNameCurrent
                        }
                    }
                }
                
                self.tableView_places.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            let detailsVC = segue.destination as? DetailsViewController
            detailsVC?.choosenId = self.selectedId
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedId = self.placeIdArray[indexPath.row]
        performSegue(withIdentifier: "toDetailVC", sender: nil)
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.placeNameArray[indexPath.row]
        return cell
    }
    
    
    @objc func addPlace() {
        // Segue
        performSegue(withIdentifier: "toAddPlace", sender: nil)
    }
    
    @objc func logOut() {
        PFUser.logOutInBackground { error in
            if error != nil {
                self.makeAlertPVC(title: "Error", message: "Ups!")
            }
            else {
                self.performSegue(withIdentifier: "toSignUpVC", sender: nil)
            }
        }
        
    }
    
    func makeAlertPVC(title : String , message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(alertButton)
        
        self.present(alert, animated: true)
    }

  

}
