//
//  PathViewController.swift
//  slg - beta - 2
//
//  Created by Sean Keenan on 7/10/16.
//  Copyright © 2016 Christina li. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PathViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var currentFox: UILabel!
    @IBOutlet weak var journeyButton: UIButton!
    
    var locationManager = CLLocationManager()
    let regionRadius : CLLocationDistance = 75.0
    var currentRegion: String! = "NA"


    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestAlwaysAuthorization()
        }
        getJSON()

        
        mapView.delegate = self
        mapView.mapType = MKMapType.standard
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
    }
    //MARK: unwrap JSON and create regions
    
    func getJSON () {
        let url = Bundle.main.url(forResource: "fox_locations", withExtension: "json")
        let data = NSData(contentsOf: url!)
        
        do {
            let json = try JSONSerialization.jsonObject(with:data! as Data, options: .allowFragments)
            
            for singleLocation in json as! Array<[String:AnyObject]> {
                if let identifiers = singleLocation["identifier"] as? String {
                    if let name = singleLocation["name"] as? String {
                        if let lat = singleLocation["location"]?["lat"] as? Double {
                            if let lng = singleLocation["location"]!["lng"]! as? Double {
                                
                                //MARK: turn locations into regions
                                let coordinate = CLLocationCoordinate2DMake(lat, lng)
                                let circularRegion = CLCircularRegion.init(center: coordinate, radius: regionRadius, identifier: identifiers)
                                locationManager.startMonitoring(for: circularRegion)
                                print ("\(circularRegion)")
                                
                                //MARK: Annotate the locations
                                let foxAnnotation = MKPointAnnotation ()
                                foxAnnotation.coordinate = coordinate
                                foxAnnotation.title = "\(name)"
                                mapView.addAnnotations([foxAnnotation])
                                
                                //MARK: Draw Circles around regions/annotations
                                let circle = MKCircle(center: coordinate, radius: regionRadius)
                                mapView.add(circle)
                            }
                        }
                    }
                }
            }
            
        } catch {
            print ("error serializing JSON: \(error)")
        }
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("NotDetermined")
        case .restricted:
            print("Restricted")
        case .denied:
            print("Denied")
        case .authorizedAlways:
            print("AuthorizedAlways")
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            print("AuthorizedWhenInUse")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
        {
            let location = locations.first!
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
            mapView.setRegion(coordinateRegion, animated: true)
            //locationManager.stopUpdatingLocation()
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Failed to initialize GPS: ", error.localizedDescription)
        }

    
    //MARK: fox image
    func mapView(_ mapView: MKMapView, viewFor annotation:MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        //MARK: image dimensions
        let foxImage = UIImage(named:"fox_image")
        let size = CGSize(width:20,height:20)
        UIGraphicsBeginImageContext(size)
        foxImage!.draw(in: CGRect(x : 0, y : 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let detailButton: UIButton = UIButton(type: UIButtonType.detailDisclosure)
        var annotationView: MKAnnotationView?
        
        if  annotationView == mapView.dequeueReusableAnnotationView(withIdentifier: identifier){
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.image = resizedImage
            annotationView?.rightCalloutAccessoryView = detailButton
        }
        else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    //MARK: Circle drawing
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor.blue
        circleRenderer.lineWidth = 2.0
        return circleRenderer
    }
    
    //MARK: Entering and exiting region events
    
    //1. user enter region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("enter \(region.identifier)")
        currentRegion = region.identifier
        currentFox.text = "Click to explore this new Fox Spot"
    }
    
    @IBAction func journeyButtonTapped(_ sender: UIButton) {
        let jvc = JourneyViewController()
        jvc.currentFox = currentRegion
        print("Current region : \(currentRegion)")
        navigationController?.pushViewController(jvc, animated: true)
    }
    

    // 2. user exit region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("exit \(region.identifier)")
        currentRegion="NA"
        currentFox.text="Please enter a new Fox Spot"

    }
    
    private func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: NSError) {
        print("Error:" + error.localizedDescription)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        print("Error:" + error.localizedDescription)
    }


}

