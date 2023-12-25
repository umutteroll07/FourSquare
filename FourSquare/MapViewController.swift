//
//  MapViewController.swift
//  FourSquare
//
//  Created by Umut Erol on 21.12.2023.
//

import UIKit
import MapKit
import Parse

class MapViewController: UIViewController  , MKMapViewDelegate , CLLocationManagerDelegate{
    
    var locationManager = CLLocationManager()
    var choosenLatitude = ""
    var choosenLongitude =  ""
    
    @IBOutlet weak var mapKitView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapKitView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addPlaceMapView))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(back))
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(choosePlace(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 3
        mapKitView.addGestureRecognizer(gestureRecognizer)

    }

    
    @objc func choosePlace(gestureRecognizer : UIGestureRecognizer) {
        
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: mapKitView)
            let coordinate = mapKitView.convert(touchPoint, toCoordinateFrom: mapKitView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = PlaceModel.sharedInstance.placeName
            annotation.subtitle = PlaceModel.sharedInstance.placeType
            mapKitView.addAnnotation(annotation)
            
            
            PlaceModel.sharedInstance.choosenLatitude = String(coordinate.latitude)
            PlaceModel.sharedInstance.choosenLongitude = String(coordinate.longitude)
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
        let region = MKCoordinateRegion(center: location, span: span)
        mapKitView.setRegion(region, animated: true)
    }
    
   
    
    @objc func addPlaceMapView() {

        let placeHolderOnMapView = PlaceModel.sharedInstance
        let object = PFObject(className: "PlaceInfo")
        object["name"] = placeHolderOnMapView.placeName
        object["type"] = placeHolderOnMapView.placeType
        object["atmosphere"] = placeHolderOnMapView.placeAtmosphere
        object["latitude"] = placeHolderOnMapView.choosenLatitude
        object["longitude"] = placeHolderOnMapView.choosenLongitude
        object["userName"] = placeHolderOnMapView.userName
       
        if let imageData = placeHolderOnMapView.imagePlace.jpegData(compressionQuality: 0.5) {
            object["imageData"] = PFFileObject(name: "image.jpg", data: imageData)
        }
        
        object.saveInBackground { succes, error in
            
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "UPS!", preferredStyle: UIAlertController.Style.alert)
                let alertButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                alert.addAction(alertButton)
                self.present(alert, animated: true)
            }
            else {
                self.performSegue(withIdentifier: "mapVCtoPlacesVC", sender: nil)
                
            }
        }
        
        
    }
    
    @objc func back() {
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }



}
