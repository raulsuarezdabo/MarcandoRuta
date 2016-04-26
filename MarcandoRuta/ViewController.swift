//
//  ViewController.swift
//  MarcandoRuta
//
//  Created by Raul Suarez Dabo on 25/04/16.
//  Copyright © 2016 es.com.suarez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Foundation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var viewMode: UISegmentedControl!
    
    private let manager = CLLocationManager()
    
    private var firstPosition: CLLocation? = nil
    
    private var previousPosition: CLLocation? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.requestWhenInUseAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (status == .AuthorizedWhenInUse) {
            self.manager.startUpdatingLocation()
            self.manager.startUpdatingHeading()
            self.map.showsUserLocation = true
        }
        else {
            self.manager.stopUpdatingLocation()
            self.map.showsUserLocation = false
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if ( self.map.annotations.count > 0) {
            // Check 50 meters distance between the last position
            if (self.manager.location!.distanceFromLocation(self.previousPosition!) > 50) {
                self.addNewAnnotation(self.manager.location!)
                self.previousPosition = self.manager.location!
            }
        }
        else {
            self.firstPosition = self.manager.location!
            self.map.centerCoordinate = self.manager.location!.coordinate
            self.previousPosition = self.manager.location!
            self.addNewAnnotation(self.manager.location!)
        }
    }

    func addNewAnnotation(initialCoordinate: CLLocation) {
        let myAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = self.manager.location!.coordinate
        myAnnotation.title = "(\(self.manager.location!.coordinate.longitude),\(self.manager.location!.coordinate.latitude))";
        myAnnotation.subtitle = "\(self.manager.location!.distanceFromLocation(self.firstPosition!)) m"
        self.map.addAnnotation(myAnnotation)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        let alerta = UIAlertController(title: "Error", message: "error \(error.code)", preferredStyle: .Alert)
        let accionOk = UIAlertAction(title: "OK", style: .Default, handler: {accion in
            //...
        })
        alerta.addAction(accionOk)
        self.presentViewController(alerta, animated: true, completion: nil)
    }

    @IBAction func zoomInAction() {
        let span = MKCoordinateSpan(latitudeDelta: 0.0075,longitudeDelta: 0.0075)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: self.manager.location!.coordinate.latitude, longitude: self.manager.location!.coordinate.longitude), span: span)
        self.map.setRegion(region, animated: true)
    }
    
    @IBAction func viewModeAction() {
        if (self.viewMode.selectedSegmentIndex == 0) {
            self.map.mapType = .Standard
        }
        if (self.viewMode.selectedSegmentIndex == 1) {
            self.map.mapType = .Satellite
        }
        if (self.viewMode.selectedSegmentIndex == 2) {
            self.map.mapType = .Hybrid
        }
    }

}

