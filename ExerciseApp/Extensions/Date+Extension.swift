//
//  Date+Extension.swift
//  ExerciseApp
//
//  Created by Jack on 6/28/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import Foundation

extension Date {
    // 前天
    var dayBeforeYesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -2, to: midnight)!
    }
    
    // 昨天
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: midnight)!
    }
    
    var midnight: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    
    // 今天0點
    var startOfToday: Date {
        return Calendar.current.date(byAdding: .day, value: 0, to: midnight)!
    }
    
    var dayEnd: Date {
        return Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }
    
    var convertDateString: String {
        let dateformatter = DateFormatter()
        let calendar = Calendar.current
        dateformatter.calendar = calendar
        dateformatter.dateFormat = "yyyy/MM/dd h:mm a"
        return dateformatter.string(from: self)
    }
}
