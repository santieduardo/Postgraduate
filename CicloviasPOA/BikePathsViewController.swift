//
//  ViewController.swift
//  CicloviasPOA
//
//  Created by iossenac on 24/09/16.
//  Copyright © 2016 Eduardo Santi. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class BikePathsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var repository = [BikePath]()
    var appDelegate: AppDelegate!
    var managedObjectContext: NSManagedObjectContext!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedObjectContext = self.appDelegate.persistentContainer.viewContext
        
        self.title = "Ciclovias"
        self.loadObjectsFromCoreData()
        //self.getJson()
    }

    // MARK: Table View
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BikePathsTableViewCell
        
        cell.name.text = self.repository[indexPath.row].name
        cell.status.image = self.setIcon(status: self.repository[indexPath.row].status)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repository.count
    }
    
    func setIcon(status: String) -> UIImage {
        if status.uppercased() == "CONCLUIDO" {
            return UIImage(named: "positive")!
        } else {
            return UIImage(named: "negative")!
        }
    }
    
    // MARK: Network
    func getJson() {
        DispatchQueue.main.async {
            let url = URL(string: "http://datapoa.com.br/api/action/datastore_search?resource_id=1b3d77b0-b628-445a-88e7-1cd460a074a4&limit=260")//253
            let urlData: Data? = try! Data(contentsOf: url!)
            
            var json: NSDictionary!
            
            if let data = urlData {
                json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                if let result = json.value(forKey: "result") as? NSDictionary {
                    if let records = result.value(forKey: "records") as? NSArray {
                        
                        var sourceLocationLatitude: Double!
                        var sourceLocationLongitude: Double!
                        var destinationLocationLatitude: Double!
                        var destinationLocationLongitude: Double!
                        var nameItem: String!
                        var statusItem: String!
                        
                        var sourceLocationCoordinate: CLLocationCoordinate2D!
                        var destinationLocationCoordinate: CLLocationCoordinate2D!
                        
                        for i in 0..<records.count {
                            let dictionary = records[i] as! NSDictionary
                            
                            if let geojson = dictionary.value(forKey: "geojson") as? String {
                                let geojsonData = geojson.data(using: String.Encoding.utf8)
                                let geojsonDictionary = try! JSONSerialization.jsonObject(with: geojsonData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                                let coordinatesTrash = geojsonDictionary.value(forKey: "coordinates") as! NSArray
                                let coordinatesFuck = coordinatesTrash[0] as! NSArray
                                
                                let initialCoordinates = coordinatesFuck[0] as! NSArray
                                let finalCoordinates = coordinatesFuck[1] as! NSArray
                                
                                sourceLocationLongitude = initialCoordinates[0] as! Double
                                sourceLocationLatitude = initialCoordinates[1] as! Double
                                
                                destinationLocationLongitude = finalCoordinates[0] as! Double
                                destinationLocationLatitude = finalCoordinates[1] as! Double
                                
                                sourceLocationCoordinate = CLLocationCoordinate2D(latitude: sourceLocationLatitude, longitude: sourceLocationLongitude)
                                destinationLocationCoordinate = CLLocationCoordinate2D(latitude: destinationLocationLatitude, longitude: destinationLocationLongitude)
                                
                                nameItem = dictionary.value(forKey: "nome") as! String
                                statusItem = dictionary.value(forKey: "situacao") as! String
                                
                                let bikePath = BikePath(sourceLocation: sourceLocationCoordinate, destinationLocation: destinationLocationCoordinate, name: nameItem, status: statusItem)
                                
                                self.repository.append(bikePath)
                                self.insertObjectToCoreData(object: bikePath)
                                self.tableView.reloadData()
                                
                                UIView.removeLoading()
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Core Data
    func insertObjectToCoreData(object: BikePath) {
        let bikePath: Path = NSEntityDescription.insertNewObject(forEntityName: "Path", into: self.managedObjectContext) as! Path
        bikePath.name = object.name
        bikePath.status = object.status
        bikePath.sourceLatitude = object.sourceLocation.latitude
        bikePath.sourceLongitude = object.sourceLocation.longitude
        bikePath.destinationLatitude = object.destinationLocation.latitude
        bikePath.destinationLongitude = object.destinationLocation.longitude
        
        do {
            try self.managedObjectContext.save()
        } catch let error as NSError {
            print("Error to save object to coredata - \(error)")
        }
    }
    
    func loadObjectsFromCoreData() {
        
        UIView.showLoading()
        
        self.managedObjectContext.perform { 
            let request: NSFetchRequest<Path> = Path.fetchRequest()
            
            do {
                let searchResults = try request.execute()
                
                if self.hasCoreData(searchResults: searchResults) {
                    for item in searchResults {
                        let bikePathRead = BikePath(
                            sourceLocation: CLLocationCoordinate2D(latitude: item.sourceLatitude, longitude: item.sourceLongitude),
                            destinationLocation: CLLocationCoordinate2D(latitude: item.destinationLatitude, longitude: item.destinationLongitude),
                            name: item.name!,
                            status: item.status!)
                        self.repository.append(bikePathRead)
                        self.tableView.reloadData()
                        
                        UIView.removeLoading()
                    }
                } else {
                    self.getJson()
                }
            
            } catch {
                print("Error to get objects from coredata")
            }
            
        }
    }
    
    func hasCoreData(searchResults: [Path]) -> Bool {
        if searchResults.count > 1 {
            return true
        }
        
        return false
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPolyline" {
            if let polylineVC = segue.destination as? PolylineViewController {
                let indexPath = self.tableView.indexPathForSelectedRow?.row
                polylineVC.model = self.repository[indexPath!]
            }
        }
    }
    
    
}
