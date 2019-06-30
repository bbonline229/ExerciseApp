//
//  StepInfo.swift
//  ExerciseApp
//
//  Created by Jack on 6/28/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import Foundation

enum WeekOfDay: Int {
    case sun = 1
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat
    
    var displayName: String {
        switch self{
        case .sun:
            return "Sun"
        case .mon:
            return "Mon"
        case .tue:
            return "Tue"
        case .wed:
            return "Wed"
        case .thu:
            return "Thu"
        case .fri:
            return "Fri"
        default:
            return "Sat"
        }
    }
}

struct PedometerInfo {
    
    let step: Int
    private let distance: Double
    private let calorie: Int
    
    var stepDescription: String {
        return "\(step)"
    }
    
    var distanceDiscription: String {
        return String(format: "%.0f", distance)
    }
    
    var calorieDiscription: String {
        return "\(calorie)"
    }

    // 計算 weekday 區間
    static func requestRangeDaysName() -> [String] {
        var days = [Int]()
        
        let today = Calendar.current.component(.weekday, from: Date())
        print("today = \(today)")
        
        for i in 0..<7 {
            var day = today - i
            if day <= 0 {
                day = 7 + day
            }
            days.append(day % 8)
        }
        
        let daysName = days.reversed().compactMap({ (day) -> String? in
            if day == today {
                return "Today"
            } else {
                return WeekOfDay(rawValue: day)?.displayName
            }
        })
        
        return daysName
    }
}

extension PedometerInfo {
    init(step: Int, distance: Double, weight: Double = 60) {
        self.step = step
        self.distance = distance
        self.calorie = Int(weight * 3.1 * distance / 4) / 1000
    }
    
    init() {
        step = 0
        distance = 0
        calorie = 0
    }
}
