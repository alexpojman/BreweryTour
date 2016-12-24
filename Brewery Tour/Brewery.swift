//
//  Brewery.swift
//  Brewery Tour
//
//  Created by Alexander Pojman on 12/14/16.
//  Copyright © 2016 Alexander Pojman. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Brewery: NSObject, MKAnnotation {
    var title: String?
    var desc: String
    var dbID: String?
    var profileImage: UIImage?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, desc: String, dbID: String, profileImage: UIImage?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.desc = desc
        self.dbID = dbID
        self.profileImage = profileImage
        self.coordinate = coordinate
    }
}
