//
//  LocationModel.swift
//  ExerciseApp
//
//  Created by Jack on 6/29/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import Foundation
import RealmSwift

class LocationModel: Object {
    
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var logitude: Double = 0
    @objc dynamic var timestamp: Int = 0
    
    convenience init(latitude: Double, logitude: Double, timestamp: Int) {
        self.init()
        
        self.latitude = latitude
        self.logitude = logitude
        self.timestamp = timestamp
    }
}
