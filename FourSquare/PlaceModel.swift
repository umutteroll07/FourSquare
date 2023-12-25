//
//  PlaceModel.swift
//  FourSquare
//
//  Created by Umut Erol on 22.12.2023.
//

import Foundation
import UIKit


class PlaceModel {
    
    static let sharedInstance = PlaceModel()
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var imagePlace = UIImage()
    var choosenLatitude =  ""
    var choosenLongitude = ""
    var userName = ""

    private init() {}
}
