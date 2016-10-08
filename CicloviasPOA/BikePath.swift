//
//  BikePath.swift
//  CicloviasPOA
//
//  Created by iossenac on 17/09/16.
//  Copyright © 2016 Eduardo Santi. All rights reserved.
//

import UIKit

import MapKit

class BikePath: NSObject {
    
    var sourceLocation: CLLocationCoordinate2D!
    var destinationLocation: CLLocationCoordinate2D!
    var name: String!
    var status: String!
    
    init(sourceLocation: CLLocationCoordinate2D, destinationLocation: CLLocationCoordinate2D, name: String!, status: String!) {
        self.sourceLocation = sourceLocation
        self.destinationLocation = destinationLocation
        self.name = name
        self.status = status
    }
    
    override init() {
        
    }
    
}
