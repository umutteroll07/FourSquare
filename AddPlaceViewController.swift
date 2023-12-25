//
//  AddPlaceViewController.swift
//  FourSquare
//
//  Created by Umut Erol on 21.12.2023.
//

import UIKit
import Parse
class AddPlaceViewController: UIViewController  , UIImagePickerControllerDelegate , UINavigationControllerDelegate{

    @IBOutlet weak var txt_placeName: UITextField!
    @IBOutlet weak var txt_placeType: UITextField!
    @IBOutlet weak var txt_placeAtmosphere: UITextField!
    @IBOutlet weak var imageView_place: UIImageView!
    
    var userName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let user = PFUser.current()
        userName = (user?.username)!
        
        
        
        
        imageView_place.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imagePicker))
        imageView_place.addGestureRecognizer(gestureRecognizer)
    }
    
    @IBAction func clicked_next(_ sender: Any) {
        
        let placeHolder = PlaceModel.sharedInstance
        if txt_placeName.text != "" && txt_placeType.text != "" && txt_placeAtmosphere.text != "" {
            if let chosenImage = imageView_place.image {
                placeHolder.placeName = txt_placeName.text!
                placeHolder.placeType = txt_placeType.text!
                placeHolder.placeAtmosphere = txt_placeAtmosphere.text!
                placeHolder.imagePlace = chosenImage
                placeHolder.userName = userName
                
            }
            performSegue(withIdentifier: "toMapView", sender: nil)

        }else {
            let alert = UIAlertController(title: "Error", message: "You have a problem!", preferredStyle: UIAlertController.Style.alert)
            let alertButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            alert.addAction(alertButton)
            self.present(alert, animated: true)
        }
    }
    
    @objc func imagePicker() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true , completion: nil )
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView_place.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
 
}
