//
//  PersonalConversions.swift
//  Conversions
//
//  Created by Daimen Ambers on 5/12/20.
//  Copyright © 2020 Daimen Ambers. All rights reserved.
//

import Foundation
import SwiftUI


// MARK: Errors
enum ConversionError: Error {
    case emptyTitle
    case emptyUnitName
    case emptyValueName
    case zerofactor
}

// MARK: Enummerations
enum Operations: String, CaseIterable, Equatable {
    case add = "addition"
    case subtract = "subtraction"
    case divide = "division"
    case multiply = "multiplication"
}

// MARK: Protocols
protocol Conv_Protocol {
    var conversion: [Conversion] { get set }
    func create(_ conversion: Conversion)
}

// MARK: Structs
/// Ouline of a Conversion
struct Conversion: Identifiable {
    
    /// Create multiple conversions that is converted from the unit.
    struct SubConversion: Identifiable, Hashable {
        var id = UUID()
        var subUnitName: String
        var factor: Float
//        var operation: Operations //Not needed as a parameter
        var result: Float? = nil
        
        mutating func calcResult(input: Float) {
            let output = input * factor
            self.result = output
        }
    }
    
    var id = UUID()
    var title: String
    var baseUnit: String
    var baseUnitValue: Float
    var subConversions: [SubConversion]
    
    init(title: String, baseUnit: String, subConversions: [SubConversion]) {
        self.title = title
        self.baseUnit = baseUnit
        self.subConversions = subConversions
        self.baseUnitValue = 1
    }

    mutating func saveEdits(title: String, baseUnit: String) throws {
        let emptyString = String()
        guard title != emptyString else {
            throw ConversionError.emptyTitle
        }
        
        guard baseUnit != emptyString else {
            throw ConversionError.emptyUnitName
        }
        
//        guard valueName != emptyString else {
//            throw ConversionError.emptyValueName
//        }
//        
//        guard factor != emptyString else {
//            throw ConversionError.zerofactor
//        }
        
        self.title = title
        self.baseUnit = baseUnit
    }
}

// MARK: Classes
///Used for creating personal conversions
class Personal: Conv_Protocol, ObservableObject, Identifiable {
    var id = UUID()
    @Published var conversion = [Conversion]() // Used to make the list of conversion on the in the Personal View
    
    func create(_ conversion: Conversion) {
        print(conversion.title)
        self.conversion.append(conversion)
    }
    
}
