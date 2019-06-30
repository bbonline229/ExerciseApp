//
//  Double+Extension.swift
//  ExerciseApp
//
//  Created by Jack on 6/29/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import Foundation

extension Int {
    func formatToTimeString(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = style
        
        guard let formattedString = formatter.string(from: TimeInterval(self)) else { return "- -" }
        
        if self < 10 {
            return "00:0\(formattedString)"
        } else if self < 60 {
            return "00:\(formattedString)"
        } else {
            return formattedString
        }
    }
    
    var formatTimeString: String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let seconds = self % 60

        let formatSecond = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        let formatMinute = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let formatHour = hours < 10 ? "0\(hours)" : "\(hours)"
        
        let formatString = (hours == 0) ? "\(formatMinute):\(formatSecond)" : "\(formatHour):\(formatMinute):\(formatSecond)"
        return formatString
    }
    
    var convertTimeStampToDate: Date {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        return date
    }
    
}
