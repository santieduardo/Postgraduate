//
//  Path+CoreDataProperties.swift
//  CicloviasPOA
//
//  Created by Eduardo Santi on 01/10/16.
//  Copyright © 2016 Eduardo Santi. All rights reserved.
//

import Foundation
import CoreData


extension Path {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Path> {
        return NSFetchRequest<Path>(entityName: "Path");
    }

    @NSManaged public var sourceLatitude: Double
    @NSManaged public var destinationLatitude: Double
    @NSManaged public var name: String?
    @NSManaged public var status: String?
    @NSManaged public var sourceLongitude: Double
    @NSManaged public var destinationLongitude: Double

}
