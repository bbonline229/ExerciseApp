//
//  RunVC.swift
//  ExerciseApp
//
//  Created by Jack on 6/28/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class StartRunVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private let locationManager = CLLocationManager()
    
    var lastLocation: CLLocation = CLLocation() {
        didSet {
            self.mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupLocation()
    }
    
    @IBAction func startRunning(_ sender: UIButton) {
        let vc = RunMainVC()
        present(vc, animated: true, completion: nil)
    }
    
    private func setup() {
        mapView.showsUserLocation = true
    }
    
    private func setupLocation() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.distanceFilter = 100
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
}

extension StartRunVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {return}
        
        self.lastLocation = lastLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("fetch location failed")
    }
}
