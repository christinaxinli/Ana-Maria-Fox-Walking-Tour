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
    
    let locationManager = CLLocationManager ()
    let regionRadius : CLLocationDistance = 75.0
    var currentRegion = String()
    
    //MARK: unwrap JSON and create regions
    
    func getJSON () {
        let url = Bundle.main().urlForResource("fox_locations", withExtension: "json")
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
                                print("yes \(name)")
                            
                            
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

    
    //MARK: Authorizing app to get location
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 1. status is not determined
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
            // 2. authorization were denied
        else if CLLocationManager.authorizationStatus() == .denied {
            let alert = UIAlertController(title: "Alert", message: "Location services were previously denied. Please enable location services for this app in Settings.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            // 3. we do have authorization
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // 2. setup locationManager
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // 3. setup mapView
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        //centerMapOnLocation(location: (CLLocation[CLLocation.count - 1]))
        
        getJSON()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: Actions
    
    //MARK: Center the map
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 10, regionRadius * 20)
        mapView.setRegion(coordinateRegion,animated: true)
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        centerMapOnLocation(location: locations[locations.count - 1]);
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
        circleRenderer.strokeColor = UIColor.blue()
        circleRenderer.lineWidth = 2.0
        return circleRenderer
    }
    
    //MARK: Entering and exiting region events
    
    //1. user enter region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("enter \(region.identifier)")
        currentRegion = region.identifier
        currentFox.text = region.identifier
    }
    
    @IBAction func journeyButtonTapped(_ sender: UIButton) {
        let jvc = JourneyViewController()
        jvc.currentFox = currentRegion
        navigationController?.pushViewController(jvc, animated: true)
    }
    

    // 2. user exit region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("exit \(region.identifier)")
        currentRegion="NA"
        currentFox.text="Go to the next Location"

    }


}

