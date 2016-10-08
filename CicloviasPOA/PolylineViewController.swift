//
//  PolylineViewController.swift
//  CicloviasPOA
//
//  Created by Eduardo Santi on 01/10/16.
//  Copyright © 2016 Eduardo Santi. All rights reserved.
//

import UIKit
import MapKit

class PolylineViewController: UIViewController, MKMapViewDelegate {

    var model = BikePath()
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.model.name
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Arial", size: 13)!, NSForegroundColorAttributeName: UIColor.black]
        
        self.setMapKit()
    }
    
    // MARK: MapKit
    func setMapKit() {
        
        // The ViewController is the delegate of the MKMapViewDelegate protocol
        self.mapView.delegate = self
        
        // Set the latitude and longtitude of the locations
        let sourceLocation = model.sourceLocation //CLLocationCoordinate2D(latitude: -30.0471114539996, longitude: -51.211805943)
        let destinationLocation = model.destinationLocation //CLLocationCoordinate2D(latitude: -30.0466880839996, longitude: -51.212130841)
        
        // Create placemark objects containing the location's coordinates
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation!, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation!, addressDictionary: nil)
        
        // MKMapitems are used for routing. This class encapsulates information about a specific point on the map
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // Annotations are added which shows the name of the placemarks
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Início"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Fim"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        // The annotations are displayed on the map
        self.mapView.showAnnotations([sourceAnnotation, destinationAnnotation], animated: true)
        
        //The MKDirectionsRequest class is used to compute the route.
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .walking
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // The route will be drawn using a polyline as a overlay view on top of the map. The region is set so both locations will be visible
        directions.calculate { (response: MKDirectionsResponse?, error: Error?) in
            if error == nil {
                let route = response?.routes[0]
                self.mapView.addOverlays([(route?.polyline)!], level: MKOverlayLevel.aboveLabels)
                
                let rect = route?.polyline.boundingMapRect
                self.mapView.setRegion(MKCoordinateRegionForMapRect(rect!) , animated: true)
            } else {
                print("Error to get the directions")
            }
        }
    }

    // MARK: MapKit Delegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
}
