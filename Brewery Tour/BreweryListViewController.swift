//
//  SecondViewController.swift
//  Brewery Tour
//
//  Created by Alexander Pojman on 12/11/16.
//  Copyright © 2016 Alexander Pojman. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase

class BreweryListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var mkMap: MKMapView!
    var ref: FIRDatabaseReference!
    var breweries = [Brewery]()
    var lastSelectedBrewery: Brewery!
    let locationManager = CLLocationManager()
   
    fileprivate let reuseIdentifier = "BreweryCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    fileprivate let itemsPerRow: CGFloat = 2
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.mkMap.delegate = self
        
        // Setup Collection View
        collectionView.delegate = self
        collectionView.dataSource = self
        
        ref = FIRDatabase.database().reference()
        ref.child("breweries").queryOrdered(byChild: "name").observe(.value, with: { snapshot in
            for item in snapshot.children {
                let name = (item as! FIRDataSnapshot).childSnapshot(forPath: "name").value as! String
                var desc = (item as! FIRDataSnapshot).childSnapshot(forPath: "description").value as? String
                let lat = (item as! FIRDataSnapshot).childSnapshot(forPath: "location").childSnapshot(forPath: "lat").value as! Double
                let lng = (item as! FIRDataSnapshot).childSnapshot(forPath: "location").childSnapshot(forPath: "lng").value as! Double
                
                if (desc == nil) {
                    desc = "No Description Available"
                }
                
                let newBrewery = Brewery(title: name, desc: desc!, dbID: (item as! FIRDataSnapshot).key, profileImage: UIImage(named: "brewery.jpg"), coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng))
                
                self.breweries.append(newBrewery)
            }
            
            self.collectionView.reloadData()
            
            // Configure Maps
            self.mkMap.addAnnotations(self.breweries)
            self.mkMap.showsUserLocation = true
            let regionRadius: CLLocationDistance = 1000
            let coordinateRegion = MKCoordinateRegionMakeWithDistance((self.locationManager.location?.coordinate)!,
                                                                      regionRadius * 2.0, regionRadius * 2.0)
            self.mkMap.setRegion(coordinateRegion, animated: true)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.breweries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! BreweryCell
        
        // Configure the custom cell
        cell.backgroundColor = UIColor.black
        cell.breweryImage.image = self.breweries[indexPath.item].profileImage
        cell.breweryNameLabel.text = self.breweries[indexPath.item].title?.uppercased()
        cell.breweryNameLabel.font = UIFont(name: "Raleway-Bold", size: 20)
        
        let attributedString = NSMutableAttributedString(string: cell.breweryNameLabel.text!)
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(5.5), range: NSRange(location: 0, length: attributedString.length))
        cell.breweryNameLabel.attributedText = attributedString
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        lastSelectedBrewery = breweries[indexPath.item]
        performSegue(withIdentifier: "showBreweryDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "showBreweryDetail") {
            
            let breweryDetailViewController = (segue.destination as! BreweryDetailViewController)
            breweryDetailViewController.brewery = lastSelectedBrewery
            
            let item = UIBarButtonItem(title: "BACK", style: .plain, target: self, action: #selector(self.navigationController?.popViewController))
            
            item.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Raleway-Regular", size: 12)!], for: .normal)
            
            navigationItem.backBarButtonItem = item
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mkMap.setRegion(region, animated: true)
        
        if let location = locations.last {
            print("Found User's location: \(location)")
            print("Latitude: \(location.coordinate.latitude) Longitude: \(location.coordinate.longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error){
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    @IBAction func ShowMapView(_ sender: UIButton) {
        mkMap.isHidden = false
        collectionView.isHidden = true
    }
    
    @IBAction func ShowListView(_ sender: UIButton) {
        mkMap.isHidden = true
        collectionView.isHidden = false
    }
}

extension BreweryListViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension BreweryListViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Brewery {
            let identifier = "pin"
            var view: BreweryAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? BreweryAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = BreweryAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.init(type: .detailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            let clickedBrew = annotationView.annotation as! Brewery
            lastSelectedBrewery = clickedBrew
            performSegue(withIdentifier: "showBreweryDetail", sender: self)
        }
    }
}

