//
//  RunModel.swift
//  ExerciseApp
//
//  Created by Jack on 6/29/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import Foundation
import RealmSwift

class RunModel: Object {
    
    @objc dynamic var distance: Double = 0.0
    @objc dynamic var duration: Int = 0
    @objc dynamic var timestamp: Int = 0
    
    let locations = List<LocationModel>()
    
    convenience init(distance: Double, duration: Int, timestamp: Int) {
        self.init()
        
        self.distance = distance
        self.duration = duration
        self.timestamp = timestamp
    }
    
    convenience init(distance: Double, duration: Int) {
        self.init()
        
        self.distance = distance
        self.duration = duration
    }    
}

extension RunModel {
    var paceDescription: String {
        if distance == 0 {
            return "- -"
        }
        
        let paceData = duration * 1000 / Int(distance)
        return "\(paceData.formatTimeString)\""
    }
    
    var distanceDescription: String {
        return "\(distance.fomateMeterToKM) km"
    }
    
    var dateDescription: String {
        return timestamp.convertTimeStampToDate.convertDateString
    }
    
    var durationDescription: String {
        return duration.formatTimeString
    }
}

extension RunModel {
    static func all(in realm: Realm = try! Realm()) -> Results<RunModel> {
        return realm.objects(RunModel.self)
            .sorted(byKeyPath: "timestamp", ascending: false)
    }
    
    func save(in realm: Realm = try! Realm()) {
        try! realm.write {
            realm.add(self)
        }
    }
    
    func delete() {
        guard let realm = realm else {return}
        
        try! realm.write {
            realm.delete(self)
        }
    }
}
