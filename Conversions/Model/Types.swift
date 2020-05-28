//
//  Types.swift
//  Types
//
//  Created by Daimen Ambers on 5/9/20.
//  Copyright © 2020 Daimen Ambers. All rights reserved.
//

import Foundation

enum UnitType: String, CaseIterable {
    case craft = "Craft"
    case cooking = "Cooking"
    case chemistry = "Chemistry"
    case distance = "Distance"
    case physics = "Physics"
    case currency = "Currency"
}

enum Distance: String, CaseIterable {
    case miles = "Miles"
    case feet = "Feet"
    case inches = "Inches"
    case yards = "Yards"
    
    init?(id: Int) {
        switch id {
        case 0: self = .feet
        case 1: self = .inches
        case 2: self = .miles
        case 3: self = .yards
        default: return nil
        }
    }
}

/// Class to handle conversions between different distances
class Distances {
    var toDistance: Distance
    var fromDistance: Distance
    
    init(to toDistance: Distance, from fromDistance: Distance) {
        self.toDistance = toDistance
        self.fromDistance = fromDistance
    }
    
    func inchesToFeet(in inches: Float) -> Float {
        let feet = inches/12
        return feet
    }
}
