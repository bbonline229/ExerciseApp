//
//  StartMainVC.swift
//  ExerciseApp
//
//  Created by Jack on 6/28/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import UIKit
import CoreLocation

class RunMainVC: UIViewController {
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    private let locationManager = CLLocationManager()
    private var locationList: [CLLocation] = []
    
    private var timer = Timer()
    
    private var distance = 0.0
    
    private var runInfo: RunModel = RunModel() {
        didSet {
            distanceLabel.text = runInfo.distance.fomateMeterToKM
            paceLabel.text = runInfo.paceDescription
        }
    }
    
    private var seconds = 0 {
        didSet {
            durationLabel.text = seconds.formatTimeString
        }
    }
    
    private var buttonStatus: Bool = true {
        didSet {
            pauseButton.isHidden = !buttonStatus
            startButton.isHidden = buttonStatus
            stopButton.isHidden = buttonStatus
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonStatus = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        runTimer()
        startLocationUpdates()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopRun()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func start(_ sender: UIButton) {
        buttonStatus = true
        startRun()
    }
    
    @IBAction func stop(_ sender: UIButton) {
        popupActionSheet(title: "Are you sure you'd like to complete this activity", message: nil, actionTitles: ["Yes, I'm done", "Cancel"], actionStyle: [.default, .cancel], action: [{ _ in
            if self.distance != 0 {
               self.saveRunData()
            }
            self.dismiss(animated: true, completion: nil)
        }, nil])
    }
    
    @IBAction func pause(_ sender: UIButton) {
        buttonStatus = false
        stopRun()
    }
    
    private func stopRun() {
        timer.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    private func startRun() {
        runTimer()
        startLocationUpdates()
    }
    
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
    
    private func saveRunData() {
        
        let runModel = RunModel(distance: distance, duration: seconds, timestamp: Int(Date().timeIntervalSince1970))
        
        for location in locationList {
            let location = LocationModel(latitude: location.coordinate.latitude, logitude: location.coordinate.longitude, timestamp: Int(location.timestamp.timeIntervalSince1970))
            runModel.locations.append(location)
        }
        
        runModel.save()
    }
    
    private func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        seconds += 1
    }
}

extension RunMainVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            //let howRecent = newLocation.timestamp.timeIntervalSinceNow
            //guard newLocation.horizontalAccuracy < 1 && abs(howRecent) < 1 else { continue }
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + delta
                
                runInfo = RunModel(distance: distance, duration: seconds)
            }

            locationList.append(newLocation)
        }
    }
}
