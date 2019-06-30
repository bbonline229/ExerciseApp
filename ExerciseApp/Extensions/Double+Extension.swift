//
//  Double+Extension.swift
//  ExerciseApp
//
//  Created by Jack on 6/29/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import Foundation

extension Double {
    var fomateDoubleToString: String {
        print(self)
        return String(format: "%.1f", self)
    }
    
    var fomateMeterToKM: String {
        return (self / 1000).fomateDoubleToString
    }
}
